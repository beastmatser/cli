# cli

A simple package to build command line apps in Odin.

## An example

```odin
package main

import "core:fmt"
import "core:strings"
import "cli"


echo :: proc(args: []string) {
    fmt.println(strings.join(args[1:], " "))
}


main :: proc() {
    app := cli.Cli {
        description = "A cli tool that echoes text.",
    }
    cli.add(
        &app,
        cli.Command{
            name = "echo",
            callback = echo,
            help = "Displays the given string.",
            nargs = cli.Args.All,
        },
    )
    cli.run(app)
}
```
