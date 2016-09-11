local logFileName = "log.txt"
local logFileThreshold = 100

local fs = require("filesystem")
local logfile = fs.open(logFileName, "a")

local function writeToFile(message)
  if fs.size(logFileName) < logFileThreshold then
    logfile:write(message)
  end
end

local function logMessage(level, message) {
    local fullMessage = '[' .. os.date("%X") .. '] [' .. level .. '] ' .. message
    print(fullMessage)
    writeToFile(fullMessage)
}

local debugLogger = {
  warn = function(message) { logMessage('WARN', message) }
  info = function(message) { logMessage('INFO', message) }
  debug = function(message) { logMessage('DEBUG', message) }
}

local infoLogger = {
  warn = function(message) { logMessage('WARN', message) }
  info = function(message) { logMessage('INFO', message) }
  debug = function(message) { }
}

local warnLogger = {
  warn = function(message) { logMessage('WARN', message) }
  info = function(message) { }
  debug = function(message) { }
}

local nullLogger = {
  warn = function(message) { }
  info = function(message) { }
  debug = function(message) { }
}

return {
  null = nullLogger,
  warn = warnLogger,
  info = infoLogger,
  debug = debugLogger
}