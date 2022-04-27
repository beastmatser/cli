package tests

import "core:testing"
import "../cli"

@test
test_remove_command :: proc(t: ^testing.T) {
    app := &cli.App{}
    cli.add(app, &cli.Command{ name = "command", aliases = []string{"alias1", "alias2"}})
    cli.remove(app, "command")
    expect(t, len(app.commands) == 0, "There should be no commands!")
    expect(t, len(app.aliases.commands) == 0, "There should be no aliases!")
}

@test
test_remove_flag :: proc(t: ^testing.T) {
    app := &cli.App{}
    cli.add_flag(app, &cli.Flag{ long = "--flag", aliases = []string{"alias1", "alias2"}})
    cli.remove_flag(app, "--flag")
    expect(t, len(app.flags) == 0, "There should be no flags!")
    expect(t, len(app.aliases.flags) == 0, "There should be no aliases!")
}
