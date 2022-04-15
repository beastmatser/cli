package cli

import "core:os"
import "core:fmt"
import "core:slice"
import "core:strings"


run :: proc(app: Cli) {
    args := os.args
    if len(args) == 1 {
        show_help(app)
        return
    }

    command_name := args[1]
    command := app.commands[args[1]]
    if (command_name == "help") && app.help == nil {
        show_help(app)
        return
    } else if !(command_name in app.commands) {
        fmt.println("Command not found")
    } else if len(args[2:]) != command.nargs {
        fmt.printf(
            "Amount of required arguments does not match, expected %i, got %i.\n",
            command.nargs,
            len(args[2:]),
        )
    }
    command.callback(args[1:])
}
