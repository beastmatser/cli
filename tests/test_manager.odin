package tests

import "core:testing"
import "core:slice"
import "core:fmt"
import "core:strings"
import "../cli"

test_arguments_flag :: proc(args: []string, app: cli.App, flag: cli.Flag) -> []string {
    manager := cli.create_manager(args)
    values := manager->get_flag(app, flag)
    return values
}

@test
test_manager :: proc(t: ^testing.T) {
    app := cli.App{}
    flag1 := cli.Flag{ long = "--test", args = 2 }
    flag2 := cli.Flag{ long = "--test2", range = [2]int{1, 2} }
    cli.add_flag(&app, &flag1)
    cli.add_flag(&app, &flag2)

    args1 := []string{"./test.exe", "--test", "1", "2"}
    values1 := test_arguments_flag(args1, app, flag1)
    expect(t, slice.equal(values1, args1[2:]), "Values should be 1, 2")

    args2 := []string{"./test.exe", "--test", "1", "2", "3"}
    values2 := test_arguments_flag(args2, app, flag1)
    expect(t, slice.equal(values2, args2[2:]), "Values should be 1, 2, 3")

    args3 := []string{"./test.exe", "--test", "1", "2", "--test2", "4", "5", "6"}
    values3 := test_arguments_flag(args3, app, flag1)
    values4 := test_arguments_flag(args3, app, flag2)
    expect(t, slice.equal(values3, args3[2:4]), "Values should be 1, 2")
    expect(t, slice.equal(values4, args3[5:]), "Values should be 4, 5, 6")
}
