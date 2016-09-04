local interfaceType = 'me_interface'
local transposerType = 'transposer'

local loaderFactory = {}
local api = {}

function loaderFactory.init(apiWrapper)
  if apiWrapper == nil then
    error("This module requires 'apiWrapper' to be loaded.")
  end
  api = {
      component = apiWrapper.component,
      aspectsDict = apiWrapper.aspectsDictionary
  }
end 

function loaderFactory.getLoader(interfaceAddress, transposerAddress, interfaceSide, furnaceSide)
  local loader = {}

  local interface = api.component.proxy(interfaceAddress)
  if interface == nil or not (interface.type == interfaceType) then
    error('Invalid interface address')
  end

  local transposer = api.component.proxy(transposerAddress)
  if transposer == nil or not (transposer.type == transposerType) then
    error('Invalid inventory manager address')
  end
  local interfaceSize = transposer.getInventorySize(interfaceSide)

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
        currentResult.aspectPerItem = api.aspectsDict.getItemByAspect(reqAspect)

      result[reqAspectIdx] = currentResult
    end

    return result
  end

  loader.load = function(aspects, amount)
    local requestedItems = getRequestedItems(aspects)
    
    -- looking for already configured items in different slots
    local validConfigurations = {}
    for reqItemIdx = 1, interfaceSize do
      local reqItem = requestedItems[reqItemIdx]
      if reqItem == nil then break end
    --  print('looking for already configured item ' .. reqItem.label)
      for configIdx = 1, interfaceSize do
        local config = interface.getInterfaceConfiguration(configIdx)
        if not (config == nil) and config.name == reqItem.name and config.label == reqItem.label then
          validConfigurations[configIdx] = true
          reqItem.configIdx = configIdx
      --    print('found in slot '..configIdx)
          break
        end
      end
    end

    -- configuring remaining items
    for reqItemIdx = 1, interfaceSize do
      local reqItem = requestedItems[reqItemIdx]
      if reqItem == null then break end     
      if reqItem.configIdx == nil then
        for configIdx = 1, interfaceSize do
          if not validConfigurations[configIdx] == true then
            validConfigurations[configIdx] = true
            reqItem.configIdx = configIdx
            interface.setInterfaceConfiguration(configIdx, reqItem.dbAddress, reqItem.entry, reqItem.maxSize)
            break
          end
        end
      end
    end

    for configIdx = 1, interfaceSize do
      if not validConfigurations[configIdx] == true then
        interface.setInterfaceConfiguration(configIdx)
      end
    end

    local transferPerCycle = 1
    -- transferring requested amount of items
    local remainingAspectCount = amount
    while remainingAspectCount > 0 do
      local totalTransferredPerCycle = 0
      for reqItemIdx = 1, interfaceSize do
        local reqItem = requestedItems[reqItemIdx]
        if reqItem == nil then break end
        local transferred = transposer.transferItem(interfaceSide, furnaceSide, transferPerCycle, reqItem.configIdx)
        local transferredCount = (transferred and transferPerCycle or 0)
        remainingAspectCount = remainingAspectCount - reqItem.aspectPerItem * transferredCount 
        if remainingAspectCount <= 0 then break end
        totalTransferredPerCycle = totalTransferredPerCycle + transferredCount
      end
      if totalTransferredPerCycle == 0 then break end
    end
  end

  return loader
end

return loaderFactory