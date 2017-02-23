-- lovecmd.lua v0.1

-- Copyright (c) 2017 Ulysse Ramage
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local cmd = {
  thread = nil,
  commands = {},
  fallback = nil
}

if type(...) == "number" then
  
  while true do
    local command = io.read() -- Reads the user input
    if command then love.thread.getChannel("COMMAND"):push(command) end
  end
  
else
  
  local filepath = (...):gsub("%.", "/") .. ".lua"
  
  local function get_arguments(command)
    local arguments = {}
    for argument in string.gmatch(command, "%S+") do
      table.insert(arguments, argument)
    end
    return arguments
  end

  function cmd.load()
    
    cmd.thread = love.thread.newThread(filepath)
    cmd.thread:start( 0 )
    
  end
  
  function cmd.update()

    local err = cmd.thread:getError()
    assert(not err, err)

    local command = love.thread.getChannel("COMMAND"):pop()
    
    if command == nil then return true end

    local arguments = get_arguments( command )
    command = arguments[1]
    
    if command == nil then return true end --double-check, TODO:
    
    if cmd.commands[command] then
      
      table.remove( arguments, 1 )
      cmd.commands[command]( unpack( arguments ) )
      
    elseif cmd.fallback then
      
      cmd.fallback( unpack( arguments ) )
      
    end
    
    love.thread.getChannel("COMMAND"):push(nil)
    
  end
  
  function cmd:on(command, callback)
    if not callback then
      cmd.fallback = command --callback <- command
    else
      cmd.commands[command] = callback
    end
  end
  
  return cmd
  
end
