package tests

import "core:testing"
import "core:fmt"
import "../cli"


@test
test_valid_long_flags :: proc(t: ^testing.T) {
    invalid_flags := []string{"", "-v", "--multiple words", "flag", "a", "--v", "--"}
    app := &cli.App{}
    for invalid_flag in invalid_flags {
        err := cli.add_flag(app, &cli.Flag{ long = invalid_flag })
        msg := fmt.aprintf("%s should be an invalid flag", invalid_flag)
        expect(t, err == cli.Error.Invalid_Flag_Name, msg)
    }
}

@test
test_valid_short_flags :: proc(t: ^testing.T) {
    invalid_flags := []string{"-", "ab", "flag", "a", "--v", "--", "- "}
    app := &cli.App{}
    for invalid_flag in invalid_flags {
        err := cli.add_flag(app, &cli.Flag{ long = invalid_flag })
        msg := fmt.aprintf("%s should be an invalid flag", invalid_flag)
        expect(t, err == cli.Error.Invalid_Flag_Name, msg)
    }
}
