
## Testing

Our non-upstream build scripts are testable.

* First `cd` into this repo's root directory.

* Then, run `bash tests/build.spec.sh` to test `build.sh`.


## Build details

Underneath, `build.sh` runs the upstream steps, which also work by hand. Reuse an
existing native clang as `HOST_CLANG`, then run the runtime and libc steps (this is
`3rd-party/builds/build_base.sh` without its two Clang steps):
`build_compiler_rt.sh`, `build_yolounwind.sh`, `build_os_include.sh`, the yolo libc
(`build_yolomusl.sh` or `build_yolo_glibc.sh`), `build_runtime.sh`, and the user
libc (`build_usermusl.sh` or `build_user_glibc.sh`). For the glibc path,
`3rd-party/builds/build_all_glibc.sh` runs these in order.

