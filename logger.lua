local logFileName = "log.txt"
local logFileThreshold = 400 * 1024

local fs = require("filesystem")
local logfile = fs.open(logFileName, "a")

local function writeToFile(message)
  if fs.size(logFileName) < logFileThreshold then
    logfile:write(message .. '\r\n')
  end
end

local function logMessage(level, message) 
    local fullMessage = '[' .. os.date("%X") .. '] [' .. level .. '] ' .. message
    print(fullMessage)
    writeToFile(fullMessage)
end

local debugLogger = {
  warn = function(message) logMessage('WARN', message) end,
  info = function(message) logMessage('INFO', message) end,
  debug = function(message) logMessage('DEBUG', message) end
}

local infoLogger = {
  warn = function(message) logMessage('WARN', message) end,
  info = function(message) logMessage('INFO', message) end,
  debug = function(message) end
}

local warnLogger = {
  warn = function(message) logMessage('WARN', message) end,
  info = function(message) end,
  debug = function(message) end
}

local nullLogger = {
  warn = function(message) end,
  info = function(message) end,
  debug = function(message) end
}

return {
  null = nullLogger,
  warn = warnLogger,
  info = infoLogger,
  debug = debugLogger
}