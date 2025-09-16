+++
title = "What the Git"
description = "A web application that allows you to enter a git command and get a simple explanation of what it does."
weight = 2

[extra]
local_image = "img/git_logo.svg"
+++

What the Git is a web application built in React using Typescript, which allows
you to type git commands and have it explained to you.

You also have access to articles on certain keywords that explain a bit more
what that git nomenclature means.

What the Git runs strictly on the front-end, parsing the command that the user
sent and matching it with definitions and commands stored in static `.ts` files.

The parsing is done using [yargs-parser](https://github.com/yargs/yargs-parser),
which is the lower level program used by yargs, a popular Javascript parsing
library.

You can try the application [live here](https://wtg.nezia.dev)!
