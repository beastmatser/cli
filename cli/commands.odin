package cli

import "core:fmt"
import "core:os"
import "core:strings"


show_help :: proc(app: App, args: []string) {
    len_longest_word: int
    for name, command in app.commands {
        if len(name) > len_longest_word {
            len_longest_word = len(name)
        }
    }
    for name, flag in app.flags {
        if len(name) > len_longest_word {
            len_longest_word = len(name)
        }
    }
    len_longest_word += 5
    fmt.println(app.description if app.description != "" else "A simple cli tool.")
    fmt.println("Usage:\n  ", args[0], "<command> [<args>]")
    fmt.println("\nCommands:" if len(app.commands) != 0 else "\n")
    for name, command in app.commands {
        fmt.printf(
            "   %s%s%s\n",
            name,
            strings.repeat(" ", len_longest_word - len(name)),
            command.help,
        )
    }
    fmt.println("\nFlags:" if len(app.flags) != 0 else "")
    for name, flag in app.flags {
        fmt.printf(
            "   %s%s%s\n",
            name,
            strings.repeat(" ", len_longest_word - len(name)),
            flag.help,
        )
    }
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
    empty_range: [2]int
    if command.args != nil && command.range == empty_range {
        fmt.println(red("Properties 'args' and 'range' cannot be set simultanously."))
        return .Invalid_Command_Properties
    } else if command.range[0] > command.range[1] {
        fmt.println(red("The first element of the range property must be smaller than its second one."))
        return .Invalid_Command_Properties
    }
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
    fmt.printf(red("'%s' cannot be removed, since it is not a command.\n"), command)
    return .Command_Not_Found
}
