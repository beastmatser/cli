package cli

import "core:fmt"
import "core:strings"


@private
aliases_length :: proc(aliases: []string) -> int {
    length: int
    for alias in aliases {
        length += len(alias) + 2
    }
    return length
}

@private
message :: proc(name: string, aliases: []string, len_longest_word: int, length_words: map[string]int, help: string) {
    fmt.printf(
        "   %s%s%s%s%s\n",
        name,
        "" if len(aliases) == 0 else ", ",
        strings.join(aliases, ", "),
        strings.repeat(" ", len_longest_word - length_words[name]),
        help,
    )
}

show_help :: proc(app: App, manager: Manager) {
    args := manager.args
    length_words := make(map[string]int)
    len_longest_word: int

    for name, command in app.commands {
        length := len(name) + aliases_length(command.aliases)
        if length > len_longest_word {
            len_longest_word = length
        }
        length_words[name] = length
    }
    for name, flag in app.flags {
        length := len(name) + aliases_length(flag.aliases)
        if length > len_longest_word {
            len_longest_word = length
        }
        length_words[name] = length
    }
    len_longest_word += 5

    fmt.println(app.description if app.description != "" else "A simple cli tool.")
    fmt.println("Usage:\n  ", args[0], "<command> [<args>]")
    fmt.println("\nCommands:" if len(app.commands) != 0 else "")
    for name, command in app.commands {
        message(name, command.aliases, len_longest_word, length_words, command.help)
    }
    fmt.println("\nFlags:" if len(app.flags) != 0 else "")
    for name, flag in app.flags {
        message(name, flag.aliases, len_longest_word, length_words, flag.help)
    }
}
