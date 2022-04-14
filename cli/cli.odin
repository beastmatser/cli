package cli

import "core:os"
import "core:fmt"
import "core:slice"
import "core:strings"


Command :: struct {
    name:     string,
    callback: proc(args: []string),
    help:     string,
}


Cli :: struct {
    description: string,
    commands:    map[string]Command,
    help:        proc(app: Cli),
}


add :: proc(app: ^Cli, command: Command) {
    if command.name == "" {
        fmt.println("A command must have a name!")
    } else if command.callback == nil {
        fmt.println("A command must have a callback!")
    }

    app^.commands[command.name] = command
}


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


run :: proc(app: Cli) {
    args := os.args
    if len(args) == 1 {
        show_help(app)
        return
    }

    command_name := args[1]
    if (command_name == "help") && app.help == nil {
        show_help(app)
        return
    } else if !(command_name in app.commands) {
        fmt.println("Command not found")
    }
    command := app.commands[command_name]
}
