local interfaceType = 'me_interface'
local transposerType = 'transposer'

local loaderFactory = {}
local api = {}

function loaderFactory.init(apiWrapper)
  if apiWrapper == nil then
    error("This module requires 'apiWrapper' to be loaded.")
  end
  api = {
      component = apiWrapper.component
      aspectsDict = apiWrapper.aspectsDictionary
  }
end 

function loaderFactory.getLoader(interfaceAddress, transposerAddress, interfaceSide, furnaceSide)
  local loader = {}

  local interface = api.component.proxy(interfaceAddress)
  if interface == nil or interface.type != interfaceType then
    error('Invalid interface address')
  end
  local interfaceSize = transposer.getInventorySize(interfaceSide)

  local transposer = api.component.proxy(interfaceAddress)
  if transposer == nil or transposer.type != transposerType then
    error('Invalid inventory manager address')
  end

  local getRequestedItems = function(aspects)
    local result = {}
    for reqAspectIdx = 1, interfaceSize do
      local reqAspect = aspects[reqAspectIdx]
      if reqAspect == nil then break end
      
      local currentResult = {}
      currentResult.label,
        currentResult.name,
        currentResult.dbAddress, 
        currentResult.entry, 
        currentResult.maxSize,
        currentResult.aspectPerItem = aspectsDict.getItemByAspect(reqAspect)

      result[reqAspectIdx] = currentResult
    end
  end

  loader.load = function(aspects, amount)
    local requestedItems = getRequestedItems(aspects)
    
    -- looking for already configured items in different slots
    local validConfigurations = {}
    for reqItemIdx = 1, interfaceSize do
      local reqItem = requestedItems[reqItemIdx]
      for configIdx = 1, interfaceSize do
        local config = interface.getInterfaceConfiguration(configIdx)
        if config.name == reqItem.name and config.label == reqItem.label then
          validConfigurations[configIdx] = true
          reqItem.configIdx = configIdx
          break
        end
      end
    end

    -- configuring remaining items
    for reqItemIdx = 1, interfaceSize do
      local reqItem = requestedItems[reqItemIdx]     
      if reqItem.configIdx == nil then
        for configIdx = 1, interfaceSize do
          if validConfigurations[configIdx] != true then
            validConfigurations[configIdx] = true
            reqItem.configIdx = configIdx
            interface.setInterfaceConfiguration(configIdx, reqItem.dbAddress, reqItem.entry, reqItem.maxSize)
            break
          end
        end
      end
    end

    -- transferring requested amount of items
    local remainingAspectCount = amount
    while remainingAspectCount > 0 do
      for reqItemIdx = 1, interfaceSize do
        local reqItem = requestedItems[reqItemIdx]
        local transferred = transposer.transferItem(interfaceSide, furnaceSide, 1, reqItem.configIdx)
        remainingAspectCount = remainingAspectCount - reqItem.aspectPerItem * transferred
        if transferred == 0 or remainingAspectCount <= 0 then break end
      end
    end
  end

  return loader
end

return loaderFactory