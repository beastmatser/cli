package cli

import "core:os"
import "core:fmt"


find_command :: proc(app: App, command_name: string) -> Error {
    if command_name in app.commands {
        return .None
    }
    fmt.printf("\x1b[31mUnknown command: %s.\x1b[0m\n", command_name)
    return .Command_Not_Found
}

validate_args :: proc(command: Command, args: []string) -> Error {
    if command.args == nil {
        return .None
    } else if command.args == len(args) {
        return .None
    }
    fmt.printf(
        "\x1b[31mCommand '%s' expected %i arguments, got %i instead.\x1b[0m\n",
        command.name,
        command.args,
        len(args),
    )
    return .Invalid_Amount_Args
}

run :: proc(app: App) -> Error {
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
    validate_args(command, args[2:]) or_return

    command.action(app, args[1:])
    return .None
}
