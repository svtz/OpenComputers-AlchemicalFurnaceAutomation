local databaseType = "database"
local component = require("component")
local fs = require("filesystem")

local function getDatabases()
  local addresses = component.list()
  
  local dbs = {}
  local dbsCount = 0;
  for k,v in pairs(addresses) do
    if v == databaseType then
      dbsCount = dbsCount + 1
      dbs[dbsCount] = component.proxy(k)
      print("Database found at " .. k)
    end
  end

  return dbs, dbsCount
end

local dbs, dbsCount = getDatabases()
local output = fs.open("db-dump.txt", "w")
if (output == nil) then error('!!!') end
for i = 1, dbsCount do
  local db = dbs[i]
  for j = 1, 100 do
    local stack
    if pcall(function() stack = db.get(j) end) then
      if not (stack == nil) then
        output:write(stack.label .. " : " .. db.computeHash(j) .. "\r\n")
      end
    else
      break
    end
  end
end
output:close()

print('Dump complete')