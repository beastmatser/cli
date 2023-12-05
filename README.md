# cli

A simple package to build command line apps in Odin.

## An example

```odin
package main

import "cli"
import "core:fmt"
import "core:strings"


action :: proc(app: cli.App, manager: cli.Manager) {
    fmt.println(strings.join(manager.args[2:], " "))
}


main :: proc() {
    app := cli.App {
        description = "This is my simple cli tool!",
    }

    cli.add(&app, &cli.Command{name = "echo", action = action})
    err := cli.run(&app)
}
```

To use your cli compile your code and move it into your path,
it should look something like this:
```
odin run app.odin -file -out:app
app echo Hello World!
> Hello World!
```