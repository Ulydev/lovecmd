io.stdout:setvbuf'no' 

local cmd = require("lovecmd")

cmd:on("test", function(val)
  if val then
    print("-first argument is " .. val)
  else
    print("-no arguments given")
  end
end)

cmd:on(function(name) print("Command " .. name .. " unknown") end)

--

function love.load()
  cmd.load() --init library
end

function love.update(dt)
  cmd.update() --update library
end

--
