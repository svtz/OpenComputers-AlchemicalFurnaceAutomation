local interfaceType = "me_interface"
local radarType = "radar"
local gasToEssentiaCoefficient = 128

local controllerFactory = {}
local api = {}

function controllerFactory.init(apiWrapper)
  if apiWrapper == nil then
    error("This module requires 'apiWrapper' to be loaded.")
  end
  api = {
      component = apiWrapper.component,
      aspectsDict = apiWrapper.aspectsDictionary
  }
end 

local function sort(lowAspects, lowAspectsAmounts, lowAspectsCount)
  local upper = lowAspectsCount
  for i = 1,upper-1 do
    if lowAspectsAmounts[i] > lowAspectsAmounts[i+1] then
      local tmp = lowAspects[i]
      lowAspects[i] = lowAspects[i+1]
      lowAspects[i+1] = tmp

      tmp = lowAspectsAmounts[i]
      lowAspectsAmounts[i] = lowAspectsAmounts[i+1]
      lowAspectsAmounts[i+1] = tmp
    end
  end
end

function controllerFactory.getController(interfaceAddress, radarAddress, aspectsList, radarRange)
  local interface = api.component.proxy(interfaceAddress)
  if interface == nil or not (interface.type == interfaceType) then
    error('Invalid interface address')
  end
  local radar = api.component.proxy(radarAddress)
  if interface == nil or not (interface.type == interfaceType) then
    error('Invalid interface address')
  end

  local controller = {}
  controller.getLowLevelAspects = function()
    local fluids = interface.getFluidsInNetwork()
    
    local lowAspects = {}
    local lowAspectsAmounts = {}
    local lowAspectsCount = 0

    for k,v in pairs(aspectsList) do
 --     print('searching for ' .. k)
      local essentiaName = k
      local requestedLevel = v
      local fluid
      local found = false
      
      -- counting essentia in the network
      for fluidIdx = 1, fluids.n do
        fluid = fluids[fluidIdx]
        if not (fluid == nil) and string.find(fluid.name, k) then
          fluids[fluidIdx] = nil
   --       print('found ' .. fluid.name)
          found = true
          break 
        end
      end
      local essentiaAmount = found and (fluid.amount / gasToEssentiaCoefficient) or 0
      
      -- currently in furnace
      local itemsInFurnace = radar.getItems(radarRange)
      for k,v in pairs(itemsInFurnace) do
        local itemLabel = v.label
        local itemAspects = aspectsDict.getByLabel(itemLabel)
        for i = 1, itemAspects.n do
          if itemAspects[i].name == essentiaName then
            essentiaAmount = essentiaAmount + v.size * itemAspects[i].perItem
            break
          end
        end
      end

      -- check if it requires refilling
      if essentiaAmount < requestedLevel then
        lowAspectsCount = lowAspectsCount + 1
        lowAspects[lowAspectsCount] = essentiaName
        lowAspectsAmounts[lowAspectsCount] = 100 - ((requestedLevel - essentiaAmount) * 100 / requestedLevel)
      end
    end

    sort(lowAspects, lowAspectsAmounts, lowAspectsCount)

    return lowAspects, lowAspectsCount
  end

  return controller
end

return controllerFactory