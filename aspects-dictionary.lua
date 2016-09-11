local databaseType = "database"

local dictionaryFactory = {}
local api = {}


function dictionaryFactory.init(apiWrapper, log)
  if apiWrapper == nil then
    error("This module requires 'apiWrapper'.")
  end
  if (apiWrapper.component == nil) then
    error("This module requires 'component' API.")  
  end
  if (log == nil) then
    error("This module requires 'log'.")  
  end
  api = {
      component = apiWrapper.component
      log = log
  }

  api.log.info("Module 'aspects-dictionary' initialized")
end

local function getDatabases()
  api.log.debug("Scanning databases")
  local addresses = api.component.list()
  local dbs = {}
  local dbsCount = 0;
  for k,v in pairs(addresses) do
    if v == databaseType then
      dbsCount = dbsCount + 1
      dbs[dbsCount] = api.component.proxy(k)
      api.log.debug("- database found: " .. k)
    end
  end

  if (dbsCount == 0) then
    api.log.warn("No databases found!")
  else
    api.log.debug("Databases found: " .. dbsCount)
  end
  return dbs, dbsCount
end

function dictionaryFactory.getDictionary(aspectsDict)
  api.log.debug("Creating dictionary")
  local dictionary = {}
  
  local dbs, dbsCount = getDatabases()

  local getItemByAspectCache = {}
  dictionary.getItemByAspect = function(aspect)
    api.log.debug('getItemByAspect: ' .. aspect)
    if not (getItemByAspectCache[aspect] == nil) then
      api.log.debug('Found in cache, ok')
      return getItemByAspectCache[aspect]
    end

    api.log.debug('Looking for aspect in the pre-configured dictionary')
    local itemInfo = aspectsDict[aspect]
    if itemInfo == nil then
      error('Could not find recipe for ' .. aspect)
    end

    api.log.debug('Searching source item in databases')
    for i = 1, dbsCount do
      local db = dbs[i]
      local stackIdx = db.indexOf(itemInfo.dbHash)
      if stackIdx >= 0 then
        api.log.debug('Found itemStack: ' .. stack.label .. ', ok')
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
    api.log.debug('getByLabel: ' .. label)
    if not (getByLabelCache[label] == nil) then
      local found = getByLabelCache[label]
      api.log.debug('Found in cache, ok')
      
      if (found.n == 0) then
        api.log.warn("Ambiguous label: " .. label)
      end
      return found
    end

    api.log.debug('Looking for ' .. label .. ' in databases')
    local candidate
    for i = 1, dbsCount do
      local db = dbs[i]
      for j = 1, 100 do
        local stack
        if pcall(function() stack = db.get(j) end) then
          if not (stack == nil) and stack.label == label then
            if candidate == nil then
              api.log.debug('- found candidate')
              candidate = db.computeHash(j)
            else
              api.log.warn('- ambiguous label: ' .. label)
              getByLabelCache[label] = aspects
              return aspects
            end
          end
        else
          break
        end
      end
    end

    api.log.debug('Searching candidate's aspects in pre-configured dictionary')
    local aspects = { n = 0 }
    for k,v in pairs(aspectsDict) do
      if v.dbHash == candidate then
        aspects.n = aspects.n + 1
        aspects[aspects.n] = { name = k, perItem = v.aspectPerItem }
        api.log.debug('- found ' .. k .. ' (' .. v.aspectPerItem .. ')')
      end
    end

    if (aspects.n > 0) then
      getByLabelCache[label] = aspects
      api.log.debug("Found .." aspects.n .. " aspects, ok")
    else
      api.log.warn("No pre-configured data for label: " .. label)
    end

    return aspects     
  end

  api.log.debug("Dictionary created")
  return dictionary
end

return dictionaryFactory
