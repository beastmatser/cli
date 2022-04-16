package cli

import "core:fmt"


clear :: proc() {
    fmt.printf("\033[H\033[2J")
}

bold :: proc(s: string) -> string {
    return fmt.aprintf("\033[1m%s\033[0m", s)
}

faint :: proc(s: string) -> string {
    return fmt.aprintf("\033[2m%s\033[0m", s)
}
dim :: faint

italic :: proc(s: string) -> string {
    return fmt.aprintf("\033[3m%s\033[0m", s)
}

underline :: proc(s: string) -> string {
    return fmt.aprintf("\033[4m%s\033[0m", s)
}

blink :: proc(s: string) -> string {
    return fmt.aprintf("\033[5m%s\033[0m", s)
}

reverse :: proc(s: string) -> string {
    return fmt.aprintf("\033[7m%s\033[0m", s)
}

hidden :: proc(s: string) -> string {
    return fmt.aprintf("\033[8m%s\033[0m", s)
}

striketrough :: proc(s: string) -> string {
    return fmt.aprintf("\033[9m%s\033[0m", s)
}

black :: proc(s: string) -> string {
    return fmt.aprintf("\033[30m%s\033[0m", s)
}

red :: proc(s: string) -> string {
    return fmt.aprintf("\033[31m%s\033[0m", s)
}

green :: proc(s: string) -> string {
    return fmt.aprintf("\033[32m%s\033[0m", s)
}

yellow :: proc(s: string) -> string {
    return fmt.aprintf("\033[33m%s\033[0m", s)
}

blue :: proc(s: string) -> string {
    return fmt.aprintf("\033[34m%s\033[0m", s)
}

magenta :: proc(s: string) -> string {
    return fmt.aprintf("\033[35m%s\033[0m", s)
}

cyan :: proc(s: string) -> string {
    return fmt.aprintf("\033[36m%s\033[0m", s)
}

white :: proc(s: string) -> string {
    return fmt.aprintf("\033[37m%s\033[0m", s)
}
