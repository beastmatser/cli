package tests

import "core:testing"
import "../cli"


@test
test_help :: proc(t: ^testing.T) {
    app1 := &cli.App{}
    cli.add_help(app1)
    cli.run(app1) // adds the help command
    expect(t, len(app1.commands) == 1, "A help command was not added!")

    app2 := &cli.App{disable_help = true}
    cli.run(app2)  // normally, this procedure would add the help command
    expect(t, len(app2.commands) == 0, "Help command was added when it should not have been!")
}
