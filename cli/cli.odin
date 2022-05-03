package cli

import "core:os"
import "core:fmt"


App :: struct {
    description:    string,
    commands:       map[string]Command,
    flags:          map[string]Flag,
    required_flags: map[string]Flag,
    action:         proc(app: App, manager: Manager),
    aliases:        Aliases,
}

Aliases :: struct {
    commands: map[string]^Command,
    flags:    map[string]^Flag,
}


add_help :: proc(app: ^App) {
    _, exists := app.flags["--help"]
    if !exists {
        add_flag(
            app,
            &Flag{
                long = "--help",
                short = "-h",
                help = "Shows this message.",
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

check_required_flags :: proc(app: App, manager: Manager) -> Error {
    for _, flag in app.required_flags {
        if !manager->has_flag(app, flag.long) {
            fmt.printf(red("Missing required flag: %s.\n"), flag.long)
            fmt.printf(red("Use --help to see all available flags.\n"))
            return .Required_Flag_Missing
        }
    }
    return .None
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
    args := os.args if len(_args) == 0 else _args
    add_help(app) // adds a help flag if it does not exist
    manager := create_manager(args)

    if len(args) == 1 || manager->has_flag(app^, "--help") {
        show_help(app^, manager)
        return .None
    }

    command_name := args[1]
    command := find_command(app^, command_name) or_return

    check_required_flags(app^, manager) or_return
    validate_args(command, args[2:]) or_return

    return invoke_action(app^, command, args[2:])
}
