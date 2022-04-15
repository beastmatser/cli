package cli


Command :: struct {
    name:     string,
    callback: proc(args: []string),
    help:     string,
    nargs:    union {
        int,
        Args,
    },
    action:   Actions,
}


Cli :: struct {
    description: string,
    commands:    map[string]Command,
    help:        proc(app: Cli),
}


// Not implemented
Args :: enum int {
    All,
}


// Not implemented
Actions :: enum u8 {
    Store,
    Store_Const,
}


Error :: enum int {
    None,
    Command_Not_Found,
    Invalid_Amount_Args,
    Invalid_Command_Callback,
    Invalid_Command_Name,
}
