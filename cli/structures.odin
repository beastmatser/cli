package cli


App :: struct {
    description:    string,
    commands:       map[string]Command,
    flags:          map[string]Flag,
    required_flags: map[string]Flag,
    action:         proc(app: App, args: []string),
    aliases:        Aliases,
    disable_help:   bool,
}

Aliases :: struct {
    commands: map[string]^Command,
    flags:    map[string]^Flag,
}


Command :: struct {
    name:    string,
    aliases: []string,
    help:    string,
    args:    Maybe(int),
    range:   [2]int,
    action:  proc(app: App, args: []string),
}


Flag :: struct {
    short:    string,
    long:     string,
    aliases:  []string,
    help:     string,
    args:     Maybe(int),
    range:    [2]int,
    action:   proc(app: App, args: []string),
    required: bool,
    choices:  []string,
}


Error :: enum int {
    None,
    Command_Not_Found,
    Flag_Not_Found,
    Help_Command_Not_Found,
    Invalid_Amount_Args,
    Invalid_Command_Name,
    Invalid_Flag_Name,
    Invalid_Properties,
}
