package cli

import "core:os"


run :: proc(app: Cli) -> Error {
    args := os.args
    if len(args) == 1 {
        show_help(app)
        return .None
    }

    command_name := args[1]
    command := app.commands[args[1]]
    if (command_name == "help") && app.help == nil {
        show_help(app)
        return .None
    } else if !(command_name in app.commands) {
        return .Command_Not_Found
    } else if len(args[2:]) != command.nargs {
        return .Invalid_Amount_Args
    }
    command.callback(args[1:])
    return .None
}
