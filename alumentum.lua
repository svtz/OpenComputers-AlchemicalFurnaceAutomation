local aspectsDict = 
{
    ['potentia']  = { ['dbHash'] = '8d2b26049f594ccaf34f830644652c981058b60f1434b8256e8304aeb5ec8fc2', aspectPerItem=2 },
    ['ignis']  = { ['dbHash'] = '8d2b26049f594ccaf34f830644652c981058b60f1434b8256e8304aeb5ec8fc2', aspectPerItem=2 },
    ['perditio']  = { ['dbHash'] = '8f87afc6b6cc8cbb3d973c5a9fa0a0973d9c2c8e2727ec389b479252058dda4f', aspectPerItem=1 }
  }

local aspectsToMaintain = {}
for k,v in pairs(aspectsDict) do
  aspectsToMaintain[k] = 7000
end

local radarRange = 3
local stacksToKeep = 4

local logger = dofile("logger.lua")
local dictFactory = dofile("aspects-dictionary.lua")
local loaderFactory = dofile("furnace-loader.lua")
local sides = require("sides")
local controllerFactory = dofile("aspect-level-controller.lua")
local component = require("component")

local log = logger.debug
log.info("Starting initialization")
local apiWrapper = 
{
    component = component
}

dictFactory.init(apiWrapper, logger.debug)
local dictionary = dictFactory.getDictionary(aspectsDict)
apiWrapper.aspectsDictionary = dictionary
loaderFactory.init(apiWrapper, logger.debug)
controllerFactory.init(apiWrapper, logger.debug)




local interfaceAddress
local transposerAddress
local radarAddress
for k,v in pairs(component.list()) do if v=="me_interface" then interfaceAddress=k end end
for k,v in pairs(component.list()) do if v=="transposer" then transposerAddress=k end end
for k,v in pairs(component.list()) do if v=="radar" then radarAddress=k end end

local loader = loaderFactory.getLoader(interfaceAddress, transposerAddress, sides.east, sides.bottom)
local controller = controllerFactory.getController(interfaceAddress, radarAddress, aspectsToMaintain, radarRange)

local radar = component.proxy(radarAddress)


log.info('Initialization complete. Starting main loop...')

-- main loop
while true do
  log.debug('main loop')

  log.debug('counting stacks in the furnace')
  local stacksInFurnace = radar.getItems(radarRange)
  local stacksInFurnaceCount = 0
  local itemsInFurnaceCount = 0
  for k,v in pairs(stacksInFurnace) do
    stacksInFurnaceCount = stacksInFurnaceCount + 1
    itemsInFurnaceCount = itemsInFurnaceCount + v.size
  end

  log.debug('in furnace, stacks: ' .. stacksInFurnaceCount .. '; items: ' .. itemsInFurnaceCount)

  local stacksCanAdd = 0
  if stacksInFurnaceCount < stacksToKeep then
    stacksCanAdd = stacksToKeep - stacksInFurnaceCount
  elseif stacksInFurnaceCount < stacksToKeep * 2 then
    local itemsInOneStack = itemsInFurnaceCount / stacksInFurnaceCount
    if itemsInOneStack < 32 then 
      stacksCanAdd = stacksToKeep * 2 - stacksInFurnaceCount  
    end
  end
  log.debug('can add: ' .. stacksCanAdd .. ' stacks')

  if stacksCanAdd > 0 then
    local lowAspects, lowAspectsCount = controller.getLowLevelAspects()
    if lowAspectsCount > 0 then
      log.debug(lowAspectsCount .. ' aspects requires refilling. Loading ' .. stacksCanAdd .. ' stacks into the furnace.')
      loader.load(lowAspects, stacksCanAdd)
    else
      log.debug('All aspects are at full capacity. Sleeping...')
      loader.load(lowAspects, 0)
      os.sleep(5)   
    end
  else
    log.debug('Furnce is full. Sleeping...')
    os.sleep(5)
  end
end