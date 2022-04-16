package cli


App :: struct {
    description:    string,
    commands:       map[string]Command,
    flags:          map[string]Flag,
    required_flags: map[string]Flag,
    help:           proc(app: App),
}

CommandBase :: struct($Args: typeid) {
    name:   string,
    action: proc(app: App, args: Args),
    help:   string,
    args:   Maybe(int),
}


Command :: CommandBase([]string)


Flag :: struct {
    using _:  CommandBase(map[string]string),
    required: bool,
    choices:  []string,
}


Error :: enum int {
    None,
    Command_Not_Found,
    Flag_Not_Found,
    Invalid_Amount_Args,
    Invalid_Command_Action,
    Invalid_Command_Name,
    Invalid_Flag_Action,
    Invalid_Flag_Name,
}
