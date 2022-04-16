package cli


Command :: struct {
    name:   string,
    action: proc(app: Cli, args: []string),
    help:   string,
    args:   Maybe(int),
}


Cli :: struct {
    description: string,
    commands:    map[string]Command,
    help:        proc(app: Cli),
}


Error :: enum int {
    None,
    Command_Not_Found,
    Invalid_Amount_Args,
    Invalid_Command_Action,
    Invalid_Command_Name,
}
