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

function dictionaryFactory.init(apiWrapper)
  if apiWrapper == nil then
    error("This module requires 'apiWrapper' to be loaded.")
  end
  api = {
      component = apiWrapper.component
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

function dictionaryFactory.getDictionary(aspectsDict)
  local dictionary = {}
  
  local dbs, dbsCount = getDatabases()

  local getItemByAspectCache = {}
  dictionary.getItemByAspect = function(aspect)
    if not (getItemByAspectCache[aspect] == nil) then
      return getItemByAspectCache[aspect]
    end
    local itemInfo = aspectsDict[aspect]
    if itemInfo == nil then
      error('Could not find recipe for ' .. aspect)
    end

    for i = 1, dbsCount do
      local db = dbs[i]
      local stackIdx = db.indexOf(itemInfo.dbHash)
      if stackIdx >= 0 then
        local stack = db.get(stackIdx)
        getItemByAspectCache[aspect] = {
          label = stack.label,
          name = stack.name,
          dbAddress = db.address,
          entry = stackIdx,
          maxSize = stack.maxSize,
          aspectPerItem = itemInfo.aspectPerItem
        }
        return getItemByAspectCache[aspect]
      end
    end

    error("Can't find itemStack for " .. aspect .. " in any of databases.")
  end

  local getByLabelCache = {}
  dictionary.getByLabel = function(label)
    local aspects = { n = 0 }
    if not (getByLabelCache[label] == nil) then
      return getByLabelCache[label]
    end
    
    local candidate
    for i = 1, dbsCount do
      local db = dbs[i]
      for j = 1, 100 do
        local stack
        if pcall(function() stack = db.get(j) end) then
          if not (stack == nil) and stack.label == label then
            if candidate == nil then
              candidate = db.computeHash(j)
            else
              getByLabelCache[label] = aspects
              return aspects
            end
          end
        else
          break
        end
      end
    end

    for k,v in pairs(aspectsDict) do
      if v.dbHash == candidate then
        aspects.n = aspects.n + 1
        aspects[aspects.n] = { name = k, perItem = v.aspectPerItem }
      end
    end

    getByLabelCache[label] = aspects
    return aspects     
  end

  return dictionary
end

return dictionaryFactory
