local interfaceType = "me_interface"
local radarType = "radar"
local gasToEssentiaCoefficient = 128

local controllerFactory = {}
local api = {}

function controllerFactory.init(apiWrapper, log)
  if apiWrapper == nil then
    error("This module requires 'apiWrapper' to be loaded.")
  end
  if (apiWrapper.component == nil) then
    error("This module requires 'component' API.")  
  end
  if (apiWrapper.aspectsDictionary == nil) then
    error("This module requires 'aspectsDictionary.")  
  end
  if (log == nil) then
    error("This module requires 'log'.")
  end
  api = {
      component = apiWrapper.component,
      aspectsDict = apiWrapper.aspectsDictionary,
      log = log
  }

  api.log.info("Module 'aspect-level-controller' initialized")
end 

local function sort(lowAspects, lowAspectsAmounts, lowAspectsCount)
  api.log.debug('Sorting aspects by fill-level')
  
  local upper = lowAspectsCount
  while upper > 1 do
    for i = 1, upper-1 do
      if lowAspectsAmounts[i] > lowAspectsAmounts[i+1] then
        local tmp = lowAspects[i]
        lowAspects[i] = lowAspects[i+1]
        lowAspects[i+1] = tmp

        tmp = lowAspectsAmounts[i]
        lowAspectsAmounts[i] = lowAspectsAmounts[i+1]
        lowAspectsAmounts[i+1] = tmp
      end
    end
    api.log.debug('- [' .. upper .. '] -> ' .. lowAspects[upper])
    upper = upper - 1    
  end
  if not (lowAspects[1] == nil) then
    api.log.debug('- [' .. 1 .. '] -> ' .. lowAspects[1])
  end
  api.log.debug('Sorting complete')
end

function controllerFactory.getController(interfaceAddress, radarAddress, aspectsList, radarRange)
  api.log.debug("Creating aspect level controller")

  local interface = api.component.proxy(interfaceAddress)
  if interface == nil or not (interface.type == interfaceType) then
    error('Invalid interface address')
  end
  local radar = api.component.proxy(radarAddress)
  if interface == nil or not (interface.type == interfaceType) then
    error('Invalid radar address')
  end

  local controller = {}
  controller.getLowLevelAspects = function()
    api.log.debug('getLowLevelAspects')
    local fluids = interface.getFluidsInNetwork()
    
    local lowAspects = {}
    local lowAspectsAmounts = {}
    local lowAspectsCount = 0

    api.log.debug('Scanning items in the furnace')
    local itemsInFurnace = radar.getItems(radarRange)

    api.log.debug('Searching low level aspects in the network')
    for k,v in pairs(aspectsList) do
      api.log.debug('- searching for ' .. k)
      local essentiaName = k
      local requestedLevel = v
      local fluid
      local found = false
      
      -- counting essentia in the network
      for fluidIdx = 1, fluids.n do
        fluid = fluids[fluidIdx]
        if not (fluid == nil) and string.find(fluid.name, k) then
          fluids[fluidIdx] = nil
          api.log.debug('- found ' .. fluid.name)
          found = true
          break 
        end
      end
      local essentiaAmount = found and (fluid.amount / gasToEssentiaCoefficient) or 0
      api.log.debug('- aspect level:' .. essentiaAmount)

      -- currently in furnace
      for k,v in pairs(itemsInFurnace) do
        api.log.debug('- item in the furnace: ' .. v.label .. ' x' .. v.size)
        local itemAspects = api.aspectsDict.getByLabel(v.label)
        for i = 1, itemAspects.n do
          if itemAspects[i].name == essentiaName then
            api.log.debug('- item with this aspect found in the furnace: ' .. v.label)
            local aspectInStack = itemAspects[i].perItem * v.size
            essentiaAmount = essentiaAmount + aspectInStack
          end
        end
      end
    
      -- check if it requires refilling
      if essentiaAmount < requestedLevel then
        lowAspectsCount = lowAspectsCount + 1
        lowAspects[lowAspectsCount] = essentiaName
        lowAspectsAmounts[lowAspectsCount] = 100 - ((requestedLevel - essentiaAmount) * 100 / requestedLevel)
        api.log.debug("- it's at low level (" .. lowAspectsAmounts[lowAspectsCount] .. "%)")
      end
    end

    sort(lowAspects, lowAspectsAmounts, lowAspectsCount)
    
    api.log.debug("Found " .. lowAspectsCount .. " low-level aspects, ok")
    return lowAspects, lowAspectsCount
  end

  api.log.debug("Aspect level controller created")
  return controller
end

return controllerFactory