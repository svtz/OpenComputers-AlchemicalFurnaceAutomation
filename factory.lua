local aspectsDict =
{
      ['arbor']         = { dbHashes = { 'da8a0d6fe2dbefc51465e3263a800a45c8e28491aba2f8bf280ed54a1abb7367' }, aspectPerItem= { 3 } }
    , ['meto']          = { dbHashes = { 'da8a0d6fe2dbefc51465e3263a800a45c8e28491aba2f8bf280ed54a1abb7367' }, aspectPerItem= { 1 } }
    , ['instrumentum']  = { dbHashes = { 'e1eb7f00c234839013ddef9f03229636d22de147adcf9fee626de1644fbf2c80' }, aspectPerItem= { 1 } }
    , ['machina']       = { dbHashes = { '3cb44f9b5008c88719725f87bf2cedc83a5d0307bb3650c66b7b43e03958cb31' }, aspectPerItem= { 1 } }
    , ['exanimis']      = { dbHashes = { '8b5883c60fb1e6cde2384682faae559a848a1e204b87b341149cffc960927199' }, aspectPerItem= { 2 } }
    , ['auram']         = { dbHashes = { '8b5883c60fb1e6cde2384682faae559a848a1e204b87b341149cffc960927199', 'e6a2b5400b7df28b380a7bc8d3d829fd27bf62edd271ecf4aef61c144147ae9d' }, aspectPerItem= { 2, 2 } }
    , ['alienis']       = { dbHashes = { 'e6a2b5400b7df28b380a7bc8d3d829fd27bf62edd271ecf4aef61c144147ae9d' }, aspectPerItem= { 2 } }
    , ['fabrico']       = { dbHashes = { '157ce4ee77cbe7dac042945ff2f01d2fda26e8b32db981b8b5d8f5b90bc9b49d' }, aspectPerItem= { 4 } }
    , ['lux']           = { dbHashes = { '21be5ee78a5946ceea8d9e00a0b32946e68c6ffe0b2e06b305f6a883f3ef09c3' }, aspectPerItem= { 1 } }
    , ['herba']         = { dbHashes = { 'd653a59fe29710ec3fe9bc1bb757e89d9ea15841d047aaf2a00097c33d12f656' }, aspectPerItem= { 2 } }
    , ['praecantatio']  = { dbHashes = { '16cede6115da3acb53ad9074b9f284f15d5c4a9be15549dc9c5020e2ef62d6d3' }, aspectPerItem= { 1 } }
    , ['potentia']      = { dbHashes = { '8d2b26049f594ccaf34f830644652c981058b60f1434b8256e8304aeb5ec8fc2' }, aspectPerItem= { 2 } }
    , ['ignis']         = { dbHashes = { '8d2b26049f594ccaf34f830644652c981058b60f1434b8256e8304aeb5ec8fc2' }, aspectPerItem= { 2 } }
    , ['terra']         = { dbHashes = { '8f87afc6b6cc8cbb3d973c5a9fa0a0973d9c2c8e2727ec389b479252058dda4f' }, aspectPerItem= { 1 } }
    , ['perditio']      = { dbHashes = { '8f87afc6b6cc8cbb3d973c5a9fa0a0973d9c2c8e2727ec389b479252058dda4f' }, aspectPerItem= { 1 } }
    , ['messis']        = { dbHashes = { '8b106d64a741bd634abb3a79b7b0708f41094c87a7fd4d91120dff483c4d742d' }, aspectPerItem= { 1 } }
    , ['fames']         = { dbHashes = { '8b106d64a741bd634abb3a79b7b0708f41094c87a7fd4d91120dff483c4d742d' }, aspectPerItem= { 1 } }
    , ['permutatio']    = { dbHashes = { '8b106d64a741bd634abb3a79b7b0708f41094c87a7fd4d91120dff483c4d742d' }, aspectPerItem= { 1 } }
    , ['vacuos']        = { dbHashes = { '15a3b59380369fe63a390d7c5a08ed674617928b081042ffff88a3bbd18e252b' }, aspectPerItem= { 4 } }
    , ['tenebrae']      = { dbHashes = { 'e53c49f599f69fc5afecbcec03c983e4e13376d67079e2c298dd18051805b2b4' }, aspectPerItem= { 1 } }
    , ['humanus']       = { dbHashes = { '2212dc39e4c9dbb7bc2d51592c446a57204e5596eae1f70e39379eba503259ac' }, aspectPerItem= { 1 } }
    , ['corpus']        = { dbHashes = { '2212dc39e4c9dbb7bc2d51592c446a57204e5596eae1f70e39379eba503259ac' }, aspectPerItem= { 2 } }
    , ['aqua']          = { dbHashes = { '72ba1b7b1161728d19a2187b74659e85289a5c4e810f5c7c1949bb0206690688', '4642aebe03d32822caf48f74ac2bab7d1aa21d11ed486fdca4e2cf26d6205901' }, aspectPerItem= { 1, 4 } }
    , ['aer']           = { dbHashes = { '5130f0deb1fea34c91a80026f1b8bf320351c155c2e6771e6fa046244ea4fc64', '72ba1b7b1161728d19a2187b74659e85289a5c4e810f5c7c1949bb0206690688' }, aspectPerItem= { 1, 1 } }
    , ['mortuus']       = { dbHashes = { 'b7dcd5ac2b95a1286ad81a1ece0d710c766622073f13903c5720b7d17c5bebda' }, aspectPerItem= { 4 } }
    , ['spiritus']      = { dbHashes = { 'b7dcd5ac2b95a1286ad81a1ece0d710c766622073f13903c5720b7d17c5bebda' }, aspectPerItem= { 4 } }
    , ['motus']         = { dbHashes = { '2b390abd03dadea55705419e8877ad14db942d6d505e83be34fd95c73e5024ca' }, aspectPerItem= { 1 } }
    , ['ordo']          = { dbHashes = { '3c6673f453dfb20629a318687bb6f0963f8d083a0092be0190dd2a31c41bba38' }, aspectPerItem= { 3 } }
    , ['gelum']         = { dbHashes = { '01c0da6d07c3c67799c7616d3869b6fce23af5fa689d58ca08a41f5c65fefcf9' }, aspectPerItem= { 1 } }
    , ['vitreus']       = { dbHashes = { '716c1a297eae5887208f2dd60f5dfdeb79dc2feb7ced61569c15c3ee18b6e354' }, aspectPerItem= { 1 } }
    , ['limus']         = { dbHashes = { 'db1c9a455954912d51efbca9670d90f1a0a544e14af768ee7edfc9ab4713c9a5' }, aspectPerItem= { 1 } }
    , ['victus']        = { dbHashes = { 'db1c9a455954912d51efbca9670d90f1a0a544e14af768ee7edfc9ab4713c9a5' }, aspectPerItem= { 1 } }
    , ['bestia']        = { dbHashes = { '7d71941d38e6fd60bb62eee1263fd65e75d9e20b26afb9cee3d2243fe43c99b0' }, aspectPerItem= { 2 } }
    , ['sensus']        = { dbHashes = { '7d71941d38e6fd60bb62eee1263fd65e75d9e20b26afb9cee3d2243fe43c99b0' }, aspectPerItem= { 2 } }
    , ['venenum']       = { dbHashes = { '7d71941d38e6fd60bb62eee1263fd65e75d9e20b26afb9cee3d2243fe43c99b0' }, aspectPerItem= { 2 } }
    , ['lucrum']        = { dbHashes = { '284a3a0b99b0144a37687127757cd58c711e50572cc4ead25d2ebeab21d48676' }, aspectPerItem= { 2 } }
    , ['metallum']      = { dbHashes = { 'e585d58f042a38f850b7a8751eab602b782115b65cdc640adcd6ec310e6f5450' }, aspectPerItem= { 1 } }
    , ['volatus']       = { dbHashes = { '5130f0deb1fea34c91a80026f1b8bf320351c155c2e6771e6fa046244ea4fc64' }, aspectPerItem= { 2 } }
    , ['iter']          = { dbHashes = { '4642aebe03d32822caf48f74ac2bab7d1aa21d11ed486fdca4e2cf26d6205901' }, aspectPerItem= { 4 } }
    , ['vitium']        = { dbHashes = { '9bac309c95aa38e845f202e3346315ed61feb8f3011e4aa73a86ebd3961ae0b9', 'b71193c337fd9dd7e6c58788ff938f6f5ed6b514009420a8a51a58fc630e828d', '1952f19e7320a78f987184c6fb1772ee4c49439b8173bce3c7be8cbcf48b0451', '332177b95701d4b8a2e3a3bdcc82439eead36b9d2e0be9b6e406678184527586' }, aspectPerItem= { 3, 3, 3, 2 } }
    , ['cognitio']      = { dbHashes = { '74213f6ca7b79de5095fe7b78fb518cd292d3ef2326edfd0a3e9519fb165a99d' }, aspectPerItem= { 8 } }
    , ['perfodio']      = { dbHashes = { '180f3f1aeaa2ca8cd5966fb5bcb32b338b0a15284b002781a42882fb88f027b0' }, aspectPerItem= { 1 } }
    , ['telum']         = { dbHashes = { '906dac0e5ed0af9b8e3e4b079620ca9f64d288c8f61fe3beda82a5121b094fa2' }, aspectPerItem= { 1 } }
    , ['tutamen']       = { dbHashes = { 'd4d6b642bf0c98ad2e7c7d327b0dc2d8b320abc44d76327b2ccdb7f5e6a33cb1', '7da04171deb9cdd85018e921ec8be515dd778db3ce5c6c8294fc359a2891312c', '3e2057b578eac1e05a5a19978c048c18748c8d3932dd6325fdc6a1ff578a73dc' }, aspectPerItem= { 1, 1, 1 } }
    , ['pannus']        = { dbHashes = { '3e2057b578eac1e05a5a19978c048c18748c8d3932dd6325fdc6a1ff578a73dc' }, aspectPerItem= { 2 } }
    , ['vinculum']      = { dbHashes = { 'b72d594751a83729a12cea46c677f815d65880a7459116378ef6a675fed62f6b' }, aspectPerItem= { 2 } }
    , ['electrum']      = { dbHashes = { '4305d6a6d39a4efe9693bbeb043953374714de1a115155fec40ed458afc0d107' }, aspectPerItem= { 1 } }
    , ['tempus']        = { dbHashes = { '3c90714ea2d5f6be545b6c67238ef25bbf235650690d903a0d28bb7814cf3840' }, aspectPerItem= { 2 } }
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