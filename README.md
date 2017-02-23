lovecmd
==============

lovecmd is a simple LÖVE interface for the console

![image](https://cdn.discordapp.com/attachments/114823075295526915/282985922495250433/Feb-19-2017_22-23-43.gif)

Setup
----------------
Require library, load it and update it
```lua
local cmd = require "lovecmd"

function love.load()
  cmd.load()
end

function love.update(dt)
  cmd.update()
end
```

Register commands (and optional fallback)
```lua
cmd:on("myCommand", function()
  print("it works!")
end)

cmd:on(function(name) print(name .. " doesn't exist) end) 
```

Usage
----------------

```lua
cmd.load()
```
initializes thread

```lua
cmd.update()
```
updates internal thread

```lua
cmd:on(command, callback)

cmd:on(callback) --default callback if command isn't registered
```
registers a command - callback is a function which takes as many arguments as your command does (e.g. function (arg1, arg2) print(arg1, arg2) end)
