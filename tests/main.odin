package tests

import "core:fmt"
import "core:os"
import "core:testing"

TEST_count := 0
TEST_fail  := 0

when ODIN_TEST {
    expect  :: testing.expect
    log     :: testing.log
} else {
    expect  :: proc(t: ^testing.T, condition: bool, message: string, loc := #caller_location) {
        TEST_count += 1
        if !condition {
            TEST_fail += 1
            fmt.printf("[%v] %v\n", loc, message)
            return
        }
    }
    log     :: proc(t: ^testing.T, v: any, loc := #caller_location) {
        fmt.printf("[%v] ", loc)
        fmt.printf("log: %v\n", v)
    }
}

main :: proc() {
    t := &testing.T{}
    test_help(t)
    test_input(t)
    test_manager(t)
    test_properties(t)
    test_remove_command(t)
    test_remove_flag(t)
    test_valid_long_flags(t)
    test_valid_short_flags(t)

    fmt.printf("%v/%v tests successful.\n", TEST_count - TEST_fail, TEST_count)
    if TEST_fail > 0 {
        os.exit(1)
    }
    os.exit(0)
}

