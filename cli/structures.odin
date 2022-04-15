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
    All,
    Any,
}


// Not implemented
Actions :: enum u8 {
    Store,
    Store_Const,
}


Error :: enum {
    None,
    Command_Not_Found,
    Invalid_Amount_Args,
    Invalid_Command_Callback,
    Invalid_Command_Name,
}
