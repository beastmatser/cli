package cli

import "core:fmt"
import "core:strings"


add_flag :: proc(app: ^App, flag: Flag) -> Error {
    flag_name := flag.name
    if flag_name == "" {
        return .Invalid_Flag_Name
    }
    if !strings.has_prefix(flag_name, "--") {
        flag_name = fmt.aprintf("--%s", flag_name)
    }
    flag_name = strings.trim_right_space(flag_name)
    flag_name = strings.trim_left_space(flag_name)
    flag_name, _ = strings.replace(flag_name, " ", "-", -1)

    app.flags[flag_name] = flag
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
