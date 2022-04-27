package cli

import "core:fmt"

check_range :: proc(args: Maybe(int), range: [2]int) -> Error {
    empty_range: [2]int
    if args != nil && range == empty_range {
        fmt.println(red("Properties 'args' and 'range' cannot be set simultanously."))
        return .Invalid_Properties
    } else if range[0] > range[1] {
        fmt.println(red("The first element of the range property must be smaller than its second one."))
        return .Invalid_Properties
    }
    return .None
}
