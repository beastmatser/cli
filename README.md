# cli

A simple package to build command line apps in Odin.

## An example

```odin
package main

import "cli"
import "core:fmt"
import "core:strings"


action :: proc(cli: cli.App, args: []string) {
    fmt.println(strings.join(args[1:], " "))
}


main :: proc() {
    app := cli.App {
        description = "This is my simple cli tool!",
    }

    cli.add(&app, cli.Command{name = "echo", action = action})
    err := cli.run(app)
}
```
