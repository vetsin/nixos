{ zsh }:''
[font]
size = 18.0

[shell]
program = "${zsh}/bin/zsh"
args = ["-l"]
#live_config_reload = true

[scrolling]
history = 30000

[bell]
animation = "Linear"

[keyboard]
bindings = [
  { key = "n", mods = "Super", action = "CreateNewWindow" },
  { key = "t", mods = "Super", action = "CreateNewTab" },
  { key = "j", mods = "Super", action = "ScrollHalfPageUp" },
  { key = "k", mods = "Super", action = "ScrollHalfPageDown" },
]
''

