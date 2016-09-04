local interfaceType = "me_interface"
local gasToEssentiaCoefficient = 128

local controllerFactory = {}
local api = {}

function controllerFactory.init(apiWrapper)
  if apiWrapper == nil then
    error("This module requires 'apiWrapper' to be loaded.")
  end
  api = {
      component = apiWrapper.component
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

function controllerFactory.getController(interfaceAddress, aspectsList)
  local interface = api.component.proxy(interfaceAddress)
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
      local essentiaName = k
      local requestedLevel = v
      local fluid
      for fluidIdx = 1, fluids.n do
        fluid = fluids[fluidIdx]
        if not fluid == nil and string.match(fluid.name, k) then
          fluids[fluidIdx] = nil
          break 
        end
      end

      local essentiaAmount = fluid.amount / gasToEssentiaCoefficient
      if essentiaAmount < requestedLevel then
        lowAspectsCount = lowAspectsCount + 1
        lowAspects[lowAspectsCount] = essentiaName
        lowAspectsAmounts[lowAspectsCount] = 100 - ((requestedLevel - essentiaAmount) * 100 / requestedLevel)
      end
    end

    sort(lowAspects, lowAspectsAmounts, lowAspectsCount)

    return lowAspects
  end
end