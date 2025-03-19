+++
title = "flocon"
description = "My personal NixOS configuration, managing my systems"
weight = 1

[extra]
local_image = "img/nix_logo.svg"
+++

Flocon is my personal NixOS configuration, which I use to manage all of my systems, from both of my workstations to my server. It's a flake based configuration, which standardizes inputshav/outputs (i.e. dependencies and configurations respectively), and allows me to version everything nicely in a `flake.lock` file, akin to something like npm.

NixOS has been so incredibly useful throughout the past year (allowing me to standardize my environments is one of the big things), and the configuration has quickly become my favorite project to maintain.

I developed a local module system that fits my use-case, as I split my machines in between desktop/server (as I only need one server, I don't need to separate more).

You can find the source code [here](https://github.com/nezia1/flocon), which contains a `README.md` detailing how everything fits together.
