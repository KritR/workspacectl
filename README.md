# workspacectl

WorkspaceCTL is a terminal application for OSX to help you manage your
workspaces in an efficient manner.

## Usage

Specify a config file in ~/.config/wsctl/config.yml. An example config file is
provided in this repo for reference.

ruby workspacectl.rb [workspace]

Any workspace defined in config can be used. If no workspace is defined, then
the default workspace is used if defined.
