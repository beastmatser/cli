package cli

import "core:os"
import "core:fmt"


find_command :: proc(app: Cli, command_name: string) -> Error {
    if command_name in app.commands {
        return .None
    }
    return .Command_Not_Found
}

check_amount_args :: proc(nargs: union {
        int,
        Args,
    }) -> Error {
    switch _ in nargs {
    case int:
        {
            if len(os.args[2:]) != nargs {
                return .Invalid_Amount_Args
            }
        }
    case Args:
        {
            switch nargs {
            case .All:
                {
                    return .None
                }
            }
        }
    }
    return .None
}


run :: proc(app: Cli) -> Error {
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
    check_amount_args(command.nargs) or_return

    command.callback(args[1:])
    return .None
}
