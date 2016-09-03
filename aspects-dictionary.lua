local databaseType = "database"

local dictionaryFactory = {}
local api = {}

--[[
local aspectsDict = 
{
    ['perditio'] = #cobblestone-stack-hash#
    ['terra'] = ...
}
--]]

function dictionary.init(apiWrapper)
  if apiWrapper == nil then
    error("This module requires 'apiWrapper' to be loaded.")
  end
  api = {
      component = apiWrapper.component
      aspectsDict = apiWrapper.aspectsDictionary
  }
end

local function getDatabases()
  local addresses = api.component.list()
  
  local dbs = {}
  local dbsCount = 0;
  for k,v in pairs(addresses) do
    if v == databaseType then
      dbsCount = dbsCount + 1
      dbs[dbsCount] = api.component.proxy(k)
    end
  end

  return dbs, dbsCount
end

function dictionaryFactory.GetDictionary(aspectsDict)
  local dictionary = {}
  
  local dbs, dbsCount = getDatabases()
  dictionary.getItemByAspect = function(aspect)
    local itemInfo = aspectsDict[aspect]
    if itemInfo = nil then
      error('Could not find recipe for ' .. aspect)
    end

    for i = 1, dbsCount do
      local db = dbs[i]
      local stackIdx = db.indexOf(itemInfo.dbHash)
      if stackIdx >= 0 then
        local stack = db.get(stackIdx)
        return stack.label, stack.name, db.address, stackIdx, stack.maxSize, itemInfo.aspectPerItem
      end
    end

    error("Can't find itemStack for " .. aspect .. " in any of databases.")
  end

  return dictionary
end

return dictionaryFactory
