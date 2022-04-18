package cli

import "core:fmt"
import "core:strings"


check_flag_name :: proc(name: string) -> Error {
    if strings.contains(name, " ") {
        fmt.println(red("A flag name cannot contains spaces."))
        return .Invalid_Command_Name
    }
    if strings.has_prefix(name, "--") && len(name) == 3 {
        fmt.println(
            red(
                "A flag name staring with two dashes must be a word, not a single character",
            ),
        )
        return .Invalid_Flag_Name
    } else if strings.has_prefix(name, "-") {
        if len(name) != 2 {
            fmt.println(
                red(
                    "A flag starting with a single dash must be followed by a single character.",
                ),
            )
            return .Invalid_Flag_Name
        } else if len(name) > 2 {
            fmt.println(red("A flag containing a word must start with two dashes."))
            return .Invalid_Flag_Name
        }
    }
    return .None
}


add_flag :: proc(app: ^App, flag: Flag) -> Error {
    if flag.name == "" {
        fmt.println(red("A flag cannot be an empty string."))
        return .Invalid_Flag_Name
    }
    check_flag_name(flag.name) or_return

    app.flags[flag.name] = flag
    if flag.required {
        app.required_flags[flag.name] = flag
    }
    return .None
}


remove_flag_by_name :: proc(app: ^App, flag: string) -> Error {
    flags := &app.flags
    if flag in flags^ {
        delete_key(flags, flag)
        return .None
    }
    return .Flag_Not_Found
}

remove_flag_by_struct :: proc(app: ^App, flag: Flag) -> Error {
    return remove_command_by_name(app, flag.name)
}
