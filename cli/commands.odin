package cli

import "core:fmt"


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

add :: proc(app: ^Cli, command: Command) {
    if command.name == "" {
        fmt.println("A command must have a name!")
    } else if command.callback == nil {
        fmt.println("A command must have a callback!")
    }

    app^.commands[command.name] = command
}

remove :: proc {
    remove_command_by_name,
    remove_command_by_struct,
}

remove_command_by_name :: proc(app: ^Cli, command: string) {
    fmt.println("remove_command_by_name")
    commands := &app^.commands
    fmt.println(commands)
    if command in commands^ {
        delete_key(commands, command)
        return
    }
    fmt.printf("'%s' cannot be removed, since this command does not exist.\n")
}

remove_command_by_struct :: proc(app: ^Cli, command: Command) {
    fmt.println("remove_command_by_struct")
    remove_command_by_name(&(app^), command.name)
}
