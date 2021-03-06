package cli

import "core:fmt"
import "core:strings"


Flag :: struct {
    short:    string,
    long:     string,
    aliases:  []string,
    help:     string,
    args:     Maybe(int),
    range:    [2]int,
    action:   proc(app: App, manager: Manager),
    required: bool,
    choices:  []string,
}


@private
check_short_flag_name :: proc(name: string) -> Error {
    switch true {
    case name == "":
        return .None
    case len(name) != 2:
        fmt.println(
            red(
                "A short flag name must have a total length of two, and the first characters must be a dash.",
            ),
        )
    case strings.contains(name, " "):
        fmt.println(red("A flag name cannot contain any whitespaces."))
    case !strings.has_prefix(name, "-"):
        fmt.println(red("A short flag name must start with a single dash."))
    case:
        return .None
    }
    return .Invalid_Flag_Name
}

@private
check_long_flag_name :: proc(name: string) -> Error {
    switch true {
    case name == "":
        fmt.println(red("A long flag name is required."))
    case !strings.has_prefix(name, "--"):
        fmt.println(red("A long flag name must start with two dashes."))
    case len(name) <= 3:
        fmt.println(red("A long flag name should be two dashes followed by at least two characters."))
    case strings.contains(name, " "):
        fmt.println(
            red(
                "A flag name must start with two dashes, if your flag name uses multiple words, replace the spaces with dashes.",
            ),
        )
    case:
        return .None
    }
    return .Invalid_Flag_Name
}


add_flag :: proc(app: ^App, flag: ^Flag) -> Error {
    check_long_flag_name(flag.long) or_return
    check_short_flag_name(flag.short) or_return

    check_range(flag.args, flag.range) or_return

    if len(flag.aliases) != 0 {
        for alias in flag.aliases {
            check_long_flag_name(alias) or_return
        }
        // only add all aliases if all are valid
        for alias in flag.aliases {
            app.aliases.flags[alias] = flag
        }
    }
    app.flags[flag.long] = flag^
    if flag.required {
        app.required_flags[flag.long] = flag^
    }
    return .None
}


remove_flag :: proc {
    remove_flag_by_name,
    remove_flag_by_struct,
}


remove_flag_by_name :: proc(app: ^App, flag: string) -> Error {
    return remove_flag_by_struct(app, app.flags[flag])
}

remove_flag_by_struct :: proc(app: ^App, flag: Flag) -> Error {
    flags := &app.flags
    if flag.long in flags {
        delete_key(flags, flag.long)
        if len(flag.aliases) != 0 {
            for alias in flag.aliases {
                delete_key(&app.aliases.flags, alias)
            }
        }
        return .None
    }
    fmt.printf(red("'%s' cannot be removed, since it is not a flag.\n"), flag.long)
    return .Flag_Not_Found
}
