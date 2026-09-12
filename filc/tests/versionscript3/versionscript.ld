bar {
    global:
        bar_baz_foo;
        ThingyStuff;
    local: *;
};
foo {
    global:
        foo;
        baz;
        thingy;
} bar;
