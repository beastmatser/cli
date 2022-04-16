package cli

import "core:os"
import "core:fmt"


find_command :: proc(app: Cli, command_name: string) -> Error {
    if command_name in app.commands {
        return .None
    }
    return .Command_Not_Found
}

validate_args :: proc(command: Command, args: []string) -> Error {
    if command.args == nil {
        return .None
    } else if command.args == len(args) {
        return .None
    }
    return .Invalid_Amount_Args
}

run :: proc(app: Cli) -> Error {
    args := os.args
    if len(args) == 1 {
        show_help(app)
        return .None
    }

    command_name := args[1]
    command := app.commands[command_name]

    if (command_name == "help") && app.help == nil {
        show_help(app)
        return .None
    }
    find_command(app, command_name) or_return
    validate_args(command, args[2:])

    command.action(app, args[1:])
    return .None
}
