---
title: "What the Git"
draft: false
tags: 
 - web
 - react
 - front-end
---
What the Git is a web application built in React using Typescript, which allows you to type git commands and have it explained to you. 

You also have access to articles on certain keywords that explain a bit more what that git nomenclature means.

What the Git runs strictly on the front-end, parsing the command that the user sent and matching it with definitions and commands stored in static `.ts` files.

The parsing is done using [yargs-parser](https://github.com/yargs/yargs-parser), which is the lower level program used by yargs, a popular Javascript parsing library.

You can try the application [live here](https://wtg.nezia.dev)!
