local databaseType = "database"
local component = require("component")
local serialization = require("serialization")
local fs = require("filesystem")
local logger = dofile("logger.lua")
local log = logger.debug

local function getDatabases()
  local addresses = component.list()
  
  local dbs = {}
  local dbsCount = 0;
  for k,v in pairs(addresses) do
    if v == databaseType then
      dbsCount = dbsCount + 1
      dbs[dbsCount] = component.proxy(k)
      log.info("Database found at " .. k)
    end
  end

  return dbs, dbsCount
end

local dbs, dbsCount = getDatabases()
local output = fs.open("db-dump.txt", "w")
if (output == nil) then error('!!!') end
for i = 1, dbsCount do
  local db = dbs[i]
  log.debug("Dumping database " .. db.address)
  for j = 1, 100 do
    log.debug("Dumping slot " .. j)
    local stack
    local status, err = pcall(function() stack = db.get(j) end)
    if status then
      if not (stack == nil) then
        output:write(stack.label .. " : " .. db.computeHash(j) .. "\r\n")
      end
    else
      log.debug('error getting stack: ' .. serialization.serialize(err, true))
      break
    end
  end
end
output:close()

log.info('Dump complete')