package cli


Command :: struct {
    name:     string,
    callback: proc(args: []string),
    help:     string,
    nargs:    union {
        int,
        Nargs,
    },
    action:   Actions,
}


Cli :: struct {
    description: string,
    commands:    map[string]Command,
    help:        proc(app: Cli),
}


// Not implemented
Nargs :: enum u8 {
    all,
    any,
}


// Not implemented
Actions :: enum u8 {
    store,
    store_const,
}
