package cli

import "core:os"
import "core:fmt"


add_help :: proc(app: ^App) {
    _, exists := app.commands["help"]
    if !exists && !app.disable_help {
        add(
            app,
            &Command{
                name = "help",
                help = "Shows this message.",
                args = 0,
                action = show_help,
            },
        )
    }
}

find_command :: proc(app: App, command_name: string) -> (Command, Error) {
    command, exists := app.commands[command_name]
    if exists {
        return command, .None
    }
    fmt.printf(red("Unknown command: %s.\n"), command_name)
    return command, .Command_Not_Found
}

validate_args :: proc(command: Command, args: []string) -> Error {
    switch true {
        case command.args == len(args):
            return .None
        case command.range[0] + command.range[1] != 0:
            if command.range[0] <= len(args) && command.range[1] >= len(args) {
                return .None
            }
            fmt.printf(
                red("Expected inbetween %i and %i arguments, got %i instead.\n"),
                command.range[0],
                command.range[1],
                len(args),
            )
        case command.args == nil:
            return .None
        case:
            fmt.printf(
                red("Expected %i arguments, got %i instead.\n"),
                command.args,
                len(args),
            )
    }
    return .Invalid_Amount_Args
}

invoke_action :: proc(app: App, command: Command, args: []string) -> Error {
    if command.action != nil {
        command.action(app, create_manager(args))
    } else {
        if app.action == nil {
            fmt.println(red("No action defined!"))
            return .Invalid_Properties
        }
        app->action(create_manager(args))
    }
    return .None
}

run :: proc(app: ^App, _args := []string{}) -> Error {
    add_help(app) // adds a help a command if it does not exist or is disabled
    args := os.args if len(_args) == 0 else _args

    if len(args) == 1 {
        help, exists := app.commands["help"]
        if !exists {
            return .Help_Command_Not_Found
        }
        help.action(app^, create_manager(args))
        return .None
    }

    command_name := args[1]
    command := find_command(app^, command_name) or_return

    validate_args(command, args[2:]) or_return

    return invoke_action(app^, command, args[2:])
}
