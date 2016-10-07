local aspectsDict = 
{
    ['arbor'] = { ['dbHash'] = 'da8a0d6fe2dbefc51465e3263a800a45c8e28491aba2f8bf280ed54a1abb7367', aspectPerItem=3 },
    ['meto'] = { ['dbHash'] = 'da8a0d6fe2dbefc51465e3263a800a45c8e28491aba2f8bf280ed54a1abb7367', aspectPerItem=1 },
    ['instrumentum']  = { ['dbHash'] = 'e1eb7f00c234839013ddef9f03229636d22de147adcf9fee626de1644fbf2c80', aspectPerItem=1 },
    ['machina']  = { ['dbHash'] = '3cb44f9b5008c88719725f87bf2cedc83a5d0307bb3650c66b7b43e03958cb31', aspectPerItem=1 },
    ['exanimis']  = { ['dbHash'] = '8b5883c60fb1e6cde2384682faae559a848a1e204b87b341149cffc960927199', aspectPerItem=2 },
    ['auram']  = { ['dbHash'] = '8b5883c60fb1e6cde2384682faae559a848a1e204b87b341149cffc960927199', aspectPerItem=2 },
    ['alienis']  = { ['dbHash'] = 'e6a2b5400b7df28b380a7bc8d3d829fd27bf62edd271ecf4aef61c144147ae9d', aspectPerItem=2 },
    ['fabrico']  = { ['dbHash'] = '157ce4ee77cbe7dac042945ff2f01d2fda26e8b32db981b8b5d8f5b90bc9b49d', aspectPerItem=4 },
    ['lux']  = { ['dbHash'] = '21be5ee78a5946ceea8d9e00a0b32946e68c6ffe0b2e06b305f6a883f3ef09c3', aspectPerItem=1 },
    ['herba']  = { ['dbHash'] = '01d5f195a0f1130a7b7afc9e98d427e1d363f0ae062efec43392e4fb5eac9e8c', aspectPerItem=2 },
    ['praecantatio']  = { ['dbHash'] = '16cede6115da3acb53ad9074b9f284f15d5c4a9be15549dc9c5020e2ef62d6d3', aspectPerItem=1 },
    ['potentia']  = { ['dbHash'] = '8d2b26049f594ccaf34f830644652c981058b60f1434b8256e8304aeb5ec8fc2', aspectPerItem=2 },
    ['ignis']  = { ['dbHash'] = '8d2b26049f594ccaf34f830644652c981058b60f1434b8256e8304aeb5ec8fc2', aspectPerItem=2 },
    ['terra']  = { ['dbHash'] = '8f87afc6b6cc8cbb3d973c5a9fa0a0973d9c2c8e2727ec389b479252058dda4f', aspectPerItem=1 },
    ['perditio']  = { ['dbHash'] = '8f87afc6b6cc8cbb3d973c5a9fa0a0973d9c2c8e2727ec389b479252058dda4f', aspectPerItem=1 },
    ['messis']  = { ['dbHash'] = '8b106d64a741bd634abb3a79b7b0708f41094c87a7fd4d91120dff483c4d742d', aspectPerItem=1 },
    ['fames']  = { ['dbHash'] = '8b106d64a741bd634abb3a79b7b0708f41094c87a7fd4d91120dff483c4d742d', aspectPerItem=1 },
    ['permutatio']  = { ['dbHash'] = '8b106d64a741bd634abb3a79b7b0708f41094c87a7fd4d91120dff483c4d742d', aspectPerItem=1 },
    ['vacuos']  = { ['dbHash'] = '15a3b59380369fe63a390d7c5a08ed674617928b081042ffff88a3bbd18e252b', aspectPerItem=4 },
    ['tenebrae']  = { ['dbHash'] = 'e53c49f599f69fc5afecbcec03c983e4e13376d67079e2c298dd18051805b2b4', aspectPerItem=1 },
    ['humanus']  = { ['dbHash'] = '2212dc39e4c9dbb7bc2d51592c446a57204e5596eae1f70e39379eba503259ac', aspectPerItem=1 },
    ['corpus']  = { ['dbHash'] = '2212dc39e4c9dbb7bc2d51592c446a57204e5596eae1f70e39379eba503259ac', aspectPerItem=2 },
    ['aqua']  = { ['dbHash'] = '72ba1b7b1161728d19a2187b74659e85289a5c4e810f5c7c1949bb0206690688', aspectPerItem=1 },
    ['aer']  = { ['dbHash'] = '72ba1b7b1161728d19a2187b74659e85289a5c4e810f5c7c1949bb0206690688', aspectPerItem=1 },
    ['mortuus']  = { ['dbHash'] = 'b7dcd5ac2b95a1286ad81a1ece0d710c766622073f13903c5720b7d17c5bebda', aspectPerItem=4 },
    ['spiritus']  = { ['dbHash'] = 'b7dcd5ac2b95a1286ad81a1ece0d710c766622073f13903c5720b7d17c5bebda', aspectPerItem=4 },
    ['motus']  = { ['dbHash'] = '2b390abd03dadea55705419e8877ad14db942d6d505e83be34fd95c73e5024ca', aspectPerItem=1 }
}

local aspectsToMaintain = {}
for k,v in pairs(aspectsDict) do
  aspectsToMaintain[k] = 7000
end

local radarRange = 4
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

local loader = loaderFactory.getLoader(interfaceAddress, transposerAddress, sides.bottom, sides.south)
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