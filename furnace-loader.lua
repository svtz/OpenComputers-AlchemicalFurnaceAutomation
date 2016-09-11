local interfaceType = 'me_interface'
local transposerType = 'transposer'

local loaderFactory = {}
local api = {}

function loaderFactory.init(apiWrapper, log)
  if apiWrapper == nil then
    error("This module requires 'apiWrapper' to be loaded.")
  end
  if (apiWrapper.component == nil) then
    error("This module requires 'component' API.")  
  end
  if (apiWrapper.aspectsDictionary == nil) then
    error("This module requires 'aspectsDictionary'.")  
  end
  if (log == nil) then
    error("This module requires 'log'.")  
  end
  api = {
      component = apiWrapper.component,
      aspectsDict = apiWrapper.aspectsDictionary,
      log = log
  }

  api.log.info("Module 'furnace-loader' initialized")
end 

function loaderFactory.getLoader(interfaceAddress, transposerAddress, interfaceSide, furnaceSide)
  api.log.debug("Creating factory loader")
  local loader = {}

  local interface = api.component.proxy(interfaceAddress)
  if interface == nil or not (interface.type == interfaceType) then
    error('Invalid interface address')
  end

  local transposer = api.component.proxy(transposerAddress)
  if transposer == nil or not (transposer.type == transposerType) then
    error('Invalid transposer address')
  end
  local interfaceSize = transposer.getInventorySize(interfaceSide)

  local getRequestedItems = function(aspects)
    api.log.debug('Transforming aspects into items')
    local result = {}
    for reqAspectIdx = 1, interfaceSize do
      local reqAspect = aspects[reqAspectIdx]
      if reqAspect == nil then break end
      
      local currentResult = api.aspectsDict.getItemByAspect(reqAspect)
      result[reqAspectIdx] = currentResult
      api.log.debug('- ' .. reqAspect .. ' -> ' .. currentResult.label)
    end

    api.log.debug('Transformation complete')
    return result
  end

  loader.load = function(aspects, amount)
    api.log.debug('load: ' .. amount .. ' stacks')
    local requestedItems = getRequestedItems(aspects)
    
    api.log.debug('Looking for already configured items in the interface')
    local validConfigurations = {}
    for reqItemIdx = 1, interfaceSize do
      local reqItem = requestedItems[reqItemIdx]
      if reqItem == nil then break end
      reqItem.configIdx = nil
      api.log.debug('- searching ' .. reqItem.label)
      for configIdx = 1, interfaceSize do
        local config = interface.getInterfaceConfiguration(configIdx)
        if not (config == nil) and config.name == reqItem.name and config.label == reqItem.label then
          validConfigurations[configIdx] = true
          reqItem.configIdx = configIdx
          api.log.debug('- found in slot ' .. configIdx)
          break
        end
      end
    end

    api.log.debug('Configuring remaining items')
    for reqItemIdx = 1, interfaceSize do
      local reqItem = requestedItems[reqItemIdx]
      if reqItem == null then break end
      api.log.debug('- configuring ' .. reqItem.label)     
      if reqItem.configIdx == nil then
        for configIdx = 1, interfaceSize do
          if not validConfigurations[configIdx] == true then
            validConfigurations[configIdx] = true
            reqItem.configIdx = configIdx
            interface.setInterfaceConfiguration(configIdx, reqItem.dbAddress, reqItem.entry, reqItem.maxSize)
            api.log.debug('- successfully configured, slot: ' .. configIdx)
            break
          end
        end
      else
        api.log.debug('- already in slot ' .. reqItem.configIdx)
      end
    end

    api.log.debug('Clearing other interface slots')
    for configIdx = 1, interfaceSize do
      if not validConfigurations[configIdx] == true then
        interface.setInterfaceConfiguration(configIdx)
        api.log.debug('- ' .. configIdx .. ' cleared')
      end
    end

    --local transferPerCycle = 1
    api.log.debug('Loading requested amount of items')
    local remainingStackCount = amount
    while remainingStackCount > 0 do
      api.log.debug('- Remaining stacks: ' .. remainingStackCount)
      local totalTransferredPerCycle = 0
      for reqItemIdx = 1, interfaceSize do
        local reqItem = requestedItems[reqItemIdx]
        if reqItem == nil then break end
        api.log.debug('- loading ' .. reqItem.maxSize .. ' of ' .. reqItem.label)
        local transferred = transposer.transferItem(interfaceSide, furnaceSide, reqItem.maxSize, reqItem.configIdx)
        local transferredCount = (transferred and 1 or 0)
        api.log.debug('- loaded ' .. transferredCount .. ' stack(s)')
        remainingStackCount = remainingStackCount - transferredCount 
        if remainingStackCount <= 0 then
           api.log.debug('- all stacks loaded. exiting') 
          break
        end
        totalTransferredPerCycle = totalTransferredPerCycle + transferredCount
      end
      if totalTransferredPerCycle == 0 then 
        api.log.debug('- No items transferred per last load cycle. exiting')
        break 
      end
    end

    api.log.debug('Loading complete, ok')
  end

  api.log.debug('Factory loader created')
  return loader
end

return loaderFactory