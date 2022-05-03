package cli

import "core:slice"


create_manager :: proc(args: []string) -> Manager {
    return Manager{ args = args, has_flag = default_has_flag, get_flag = default_get_flag }
}

get_flag_names :: proc(app: App, flag_name: string) -> []string {
    for _, flag in app.flags {
        flag_names := [dynamic]string{flag.long, flag.short}
        for alias in flag.aliases {
            append(&flag_names, alias)
        }
        if slice.contains(flag_names[:], flag_name) {
            return flag_names[:]
        }
    }
    return []string{}
}

get_all_flag_names :: proc(app: App) -> []string {
    all_flag_names := [dynamic]string{}
    for _, flag in app.flags {
        append(&all_flag_names, flag.long)
        if flag.short != "" {
            append(&all_flag_names, flag.short)
        }
        for alias in flag.aliases {
            append(&all_flag_names, alias)
        }
    }
    return all_flag_names[:]
}

default_has_flag :: proc(manager: Manager, app: App, flag: string) -> bool {
    flag_names := get_flag_names(app, flag)
    for arg in manager.args {
        if slice.contains(flag_names[:], arg) {
            return true
        }
    }
    return false
}

default_get_flag :: proc(manager: Manager, app: App, flag: string) -> []string {
    flag_names := get_flag_names(app, flag)
    all_flag_names := get_all_flag_names(app)

    values := [dynamic]string{}
    loop: for arg, n in manager.args {
        if slice.contains(flag_names[:], arg) {
            for i := n + 1; i < len(manager.args); i += 1 {
                if slice.contains(all_flag_names[:], manager.args[i]) {
                    break loop
                }
                append(&values, manager.args[i])
            }
        }
    }
    return values[:]
}
