package tests

import "core:testing"
import "core:fmt"
import "../cli"


@test
test_properties :: proc(t: ^testing.T) {
    app := &cli.App{}
    err1 := cli.add(app, &cli.Command{ name = "test", args = 3, range = [2]int{1, 2}})
    expect(t, err1 == cli.Error.Invalid_Properties, "Properties args and range should be mutually exclusive!")

    err2 := cli.add_flag(app, &cli.Flag{ long = "--flag", args = 3, range = [2]int{1, 2}})
    expect(t, err2 == cli.Error.Invalid_Properties, "Properties args and range should be mutually exclusive!")

    err3 := cli.add(app, &cli.Command{ name = "test", range = [2]int{3, 2}})
    expect(t, err3 == cli.Error.Invalid_Properties, "The first element of range should be less than the second!")

    cli.add_flag(app, &cli.Flag{ long = "--flag", required = true })
    expect(t, "--flag" in app.required_flags, "Required flag should be added to required_flags!")
}

dummy :: proc(app: cli.App, args: []string) {}

@test
test_input :: proc(t: ^testing.T) {
    app := &cli.App{ action = dummy }
    cli.add(app, &cli.Command{ name = "test", args = 1 })
    err1 := cli.run(app, []string{"./test.exe", "test", "1"})
    expect(t, err1 == cli.Error.None, "Correct amount of arguments should not return an error!")

    err2 := cli.run(app, []string{"./test.exe", "test", "1", "2"})
    expect(t, err2 == cli.Error.Invalid_Amount_Args, "Too many arguments should return an error!")

    err3 := cli.run(app, []string{"./test.exe", "test"})
    expect(t, err3 == cli.Error.Invalid_Amount_Args, "Too few arguments should return an error!")

    cli.add(app, &cli.Command{ name = "test2", range = [2]int{1, 3} })
    err4 := cli.run(app, []string{"./test.exe", "test2", "1"})
    expect(t, err4 == cli.Error.None, "Correct amount of arguments should not return an error!")

    err5 := cli.run(app, []string{"./test.exe", "test2", "1", "2"})
    expect(t, err5 == cli.Error.None, "Correct amount of arguments should not return an error!")

    err6 := cli.run(app, []string{"./test.exe", "test2", "1", "2", "3"})
    expect(t, err6 == cli.Error.None, "Correct amount of arguments should not return an error!")

    err7 := cli.run(app, []string{"./test.exe", "test2", "1", "2", "3", "4"})
    expect(t, err7 == cli.Error.Invalid_Amount_Args, "Too many arguments should return an error!")
}
