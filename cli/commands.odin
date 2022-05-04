package cli

import "core:fmt"
import "core:strings"


Command :: struct {
    name:    string,
    aliases: []string,
    help:    string,
    args:    Maybe(int),
    range:   [2]int,
    action:  proc(app: App, manager: Manager),
}


add :: proc(app: ^App, command: ^Command) -> Error {
    if command.name == "" || strings.contains(command.name, " ") {
        fmt.printf(
            red(
                "'%s' is not a valid command name, a command cannot contain spaces or be empty.\n",
            ),
            command.name,
        )
        return .Invalid_Command_Name
    }
    check_range(command.args, command.range) or_return

    if len(command.aliases) != 0 {
        for alias in command.aliases {
            app.aliases.commands[alias] = command
        }
    }

    app.commands[command.name] = command^
    return .None
}

remove :: proc {
    remove_command_by_name,
    remove_command_by_struct,
}

remove_command_by_name :: proc(app: ^App, command: string) -> Error {
    return remove_command_by_struct(app, app.commands[command])
}

remove_command_by_struct :: proc(app: ^App, command: Command) -> Error {
    commands := &app.commands
    if command.name in commands^ {
        delete_key(commands, command.name)
        if len(command.aliases) != 0 {
            for alias in command.aliases {
                delete_key(&app.aliases.commands, alias)
            }
        }
        return .None
    }
    fmt.printf(red("'%s' cannot be removed, since it is not a command.\n"), command.name)
    return .Command_Not_Found
}
