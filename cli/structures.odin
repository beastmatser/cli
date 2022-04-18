package cli


App :: struct {
    description:    string,
    commands:       map[string]Command,
    flags:          map[string]Flag,
    required_flags: map[string]Flag,
    action:         proc(app: App, args: []string),
}


Command :: struct {
    name:   string,
    help:   string,
    args:   Maybe(int),
    action: proc(app: App, args: []string),
}


Flag :: struct {
    using command: Command,
    required:      bool,
    choices:       []string,
}


Error :: enum int {
    None,
    Command_Not_Found,
    Flag_Not_Found,
    Invalid_Amount_Args,
    Invalid_Command_Name,
    Invalid_Flag_Name,
}
