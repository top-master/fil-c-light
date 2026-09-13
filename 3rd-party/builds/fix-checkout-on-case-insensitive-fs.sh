#!/bin/bash
#
# fix-checkout-on-case-insensitive-fs.sh -- make a git repo with case-colliding paths behave
# on a case-insensitive filesystem (macOS APFS / HFS+ default).
#
# The problem: if the repo tracks both Foo.h and foo.h, the filesystem can
# only hold one of them. Whichever loses the race is permanently "modified"
# as far as git is concerned, and there is no way to clean it. sparse-checkout
# cannot fix this: it refuses to set SKIP_WORKTREE on a path with local
# modifications, which is precisely every path you need it to act on. It will
# happily delete the files first, though, which is how you end up with a pile
# of staged deletions.
#
# What this does instead:
#   1. finds every case-collision group in the index
#   2. resets those index entries to HEAD (clearing any staged deletions)
#   3. restores what the filesystem can actually hold
#   4. sets SKIP_WORKTREE so git stops stat'ing them
#   5. records the list in .git/ so future-you knows why git looks haunted
#
# This is a workaround, not a fix. The fix is a case-sensitive APFS volume:
#   diskutil apfs addVolume diskN "Case-sensitive APFS" src
#
# Usage:
#   fix-checkout-on-case-insensitive-fs.sh [--no-restore] [--disable-sparse] [--dry-run]
#   fix-checkout-on-case-insensitive-fs.sh --list
#   fix-checkout-on-case-insensitive-fs.sh --undo

set -euo pipefail

# Paths from the index go back to git verbatim. Without this, a path
# containing '*' or a leading ':' is read as pathspec magic.
export GIT_LITERAL_PATHSPECS=1

PROG=${0##*/}
RESTORE=1
DISABLE_SPARSE=0
DRY_RUN=0
MODE=fix

usage() {
	cat <<EOF
usage: $PROG [options]

  --no-restore      don't try to check the colliding paths back out; leave
                    whatever is on disk (or absent) as-is
  --disable-sparse  run 'git sparse-checkout disable' first. Required if the
                    repo has sparse-checkout enabled, since it fights with
                    SKIP_WORKTREE. Destroys your sparse config.
  --dry-run         report what would happen, touch nothing
  --list            list paths currently carrying SKIP_WORKTREE, then exit
  --undo            clear the bits this script set, then exit
  -h, --help        this
EOF
}

while (($#)); do
	case $1 in
	--no-restore) RESTORE=0 ;;
	--disable-sparse) DISABLE_SPARSE=1 ;;
	--dry-run) DRY_RUN=1 ;;
	--list) MODE=list ;;
	--undo) MODE=undo ;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		printf '%s: unknown option: %s\n' "$PROG" "$1" >&2
		usage >&2
		exit 2
		;;
	esac
	shift
done

die() {
	printf '%s: %s\n' "$PROG" "$1" >&2
	exit 1
}
note() { printf '  %s\n' "$1"; }

root=$(git rev-parse --show-toplevel 2>/dev/null) ||
	die "not inside a git working tree"
cd "$root"

# --git-path resolves correctly under linked worktrees, unlike .git/foo
RECORD=$(git rev-parse --git-path case-collision-skiplist)

# ---------------------------------------------------------------- list/undo

skipped() { git ls-files -t | sed -n 's/^S //p'; }

case $MODE in
list)
	n=$(skipped | wc -l | tr -d ' ')
	printf 'SKIP_WORKTREE is set on %s path(s)\n' "$n"
	skipped
	[[ -f $RECORD ]] && printf '\nrecorded by %s at %s\n' "$PROG" "$RECORD"
	exit 0
	;;
undo)
	if [[ -f $RECORD ]]; then
		src=$RECORD
	else
		printf '%s: no record at %s; clearing ALL SKIP_WORKTREE bits\n' \
			"$PROG" "$RECORD" >&2
		src=$(mktemp)
		skipped >"$src"
	fi
	if [[ ! -s $src ]]; then
		echo "nothing to undo"
		exit 0
	fi
	n=$(wc -l <"$src" | tr -d ' ')
	git update-index --no-skip-worktree --stdin <"$src"
	rm -f "$RECORD"
	printf 'cleared %s path(s). git status will now be a mess again.\n' "$n"
	exit 0
	;;
esac

# ------------------------------------------------------------------- checks

gitdir=$(git rev-parse --absolute-git-dir)
probe=$(mktemp -d "$gitdir/casetest.XXXXXX")
trap 'rm -rf "$probe"' EXIT
: >"$probe/case"
if [[ -e $probe/CASE ]]; then
	note "filesystem is case-insensitive (expected on macOS)"
else
	printf '%s: this filesystem is case-sensitive -- you do not need this.\n' \
		"$PROG" >&2
	printf '%s: continuing anyway, but check you are on the right volume.\n' \
		"$PROG" >&2
fi

sparse=$(git config --bool --get core.sparseCheckout 2>/dev/null || echo false)
if [[ $sparse == true ]]; then
	if ((DISABLE_SPARSE)); then
		note "disabling sparse-checkout"
		((DRY_RUN)) || git sparse-checkout disable
	else
		die "sparse-checkout is enabled and will fight this. Re-run with
       --disable-sparse (this discards your sparse config), or run
       'git sparse-checkout disable' yourself first."
	fi
fi

# ------------------------------------------------------- find the collisions

# tolower() is ASCII-only; APFS folds Unicode. Collisions that differ only in
# non-ASCII case will be missed. If status still shows stragglers afterwards,
# that is the first thing to check.
tmp=$(mktemp)
trap 'rm -rf "$probe"; rm -f "$tmp"' EXIT

{
	git -c core.quotePath=false ls-files
	# Paths whose deletion is already staged are gone from the index but
	# still collide. Pull them back in from HEAD.
	if git rev-parse --verify -q HEAD >/dev/null; then
		git -c core.quotePath=false ls-tree -r --name-only HEAD
	fi
} | sort -u | awk '
	{ k = tolower($0); n[k]++; g[k] = g[k] $0 "\n" }
	END { for (k in n) if (n[k] > 1) printf "%s", g[k] }
' | sort -f >"$tmp"

count=$(wc -l <"$tmp" | tr -d ' ')
if ((count == 0)); then
	echo "no case collisions in the index. Nothing to do."
	exit 0
fi
note "found $count colliding path(s) in $(sort -uf "$tmp" | wc -l | tr -d ' ') group(s)"

if grep -q '^"' "$tmp"; then
	printf '%s: some paths came back quoted (embedded newline or quote).\n' \
		"$PROG" >&2
	printf '%s: those will not round-trip; handle them by hand.\n' "$PROG" >&2
	grep '^"' "$tmp" >&2
	die "refusing to continue"
fi

if ((DRY_RUN)); then
	echo
	cat "$tmp"
	echo
	echo "(dry run -- nothing changed)"
	exit 0
fi

cp "$tmp" "$RECORD"

# ------------------------------------------------------------------- repair

# Clear any bits already set on these paths so reset/checkout behave
# predictably, then put the index entries back to HEAD. This is what clears
# the staged deletions left behind by a failed sparse-checkout.
git update-index --no-skip-worktree --stdin <"$RECORD" 2>/dev/null || true
note "resetting index entries to HEAD"
git reset -q --pathspec-from-file="$RECORD"

if ((RESTORE)); then
	note "restoring files (one member of each group wins; that is fine)"
	git checkout -q --pathspec-from-file="$RECORD" -- 2>/dev/null || true
fi

note "setting SKIP_WORKTREE"
git update-index --skip-worktree --stdin <"$RECORD"

# ------------------------------------------------------------------- verify

dirty=$(git status --porcelain --untracked-files=no | wc -l | tr -d ' ')
marked=$(skipped | wc -l | tr -d ' ')

echo
printf 'SKIP_WORKTREE set on %s path(s); list saved to %s\n' "$marked" "$RECORD"
if ((dirty == 0)); then
	echo "working tree is clean."
else
	printf 'still %s dirty path(s) -- these are NOT case collisions:\n' "$dirty"
	git status --short --untracked-files=no
fi

cat <<'EOF'

Notes:
  - Do not run 'git checkout -- <that subtree>' again. It re-materializes the
    collision on disk.
  - A pull/merge/rebase touching these paths will refuse with a "local changes"
    error rather than doing anything sensible. Run --undo, do the operation,
    run this script again.
  - 'git ls-files -t | grep "^S "' is how you rediscover what is going on.
EOF
