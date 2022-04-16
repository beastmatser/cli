package cli

import "core:fmt"
import "core:os"
import "core:strings"


show_help :: proc(app: Cli) {
    len_longest_word: int
    for name, command in app.commands {
        if len(name) > len_longest_word {
            len_longest_word = len(name)
        }
    }
    len_longest_word += 5
    fmt.println(app.description if app.description != "" else "A simple cli tool.")
    fmt.println("Usage:\n  ", os.args[0], "<command> [<args>]\n")
    for name, command in app.commands {
        fmt.printf(
            "   %s%s%s\n",
            name,
            strings.repeat(" ", len_longest_word - len(name)),
            command.help,
        )
    }
}

add :: proc(app: ^Cli, command: Command) -> Error {
    if command.name == "" {
        return .Invalid_Command_Name
    } else if command.action == nil {
        return .Invalid_Command_Action
    }

    app^.commands[command.name] = command
    return .None
}

remove :: proc {
    remove_command_by_name,
    remove_command_by_struct,
}

remove_command_by_name :: proc(app: ^Cli, command: string) -> Error {
    commands := app^.commands
    if command in commands {
        delete_key(&commands, command)
        return .None
    }
    return .Command_Not_Found
}

remove_command_by_struct :: proc(app: ^Cli, command: Command) -> Error {
    return remove_command_by_name(app, command.name)
}
