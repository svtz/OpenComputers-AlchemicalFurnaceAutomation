local aspectsDict = 
{
    ['arbor'] = { ['dbHash'] = 'da8a0d6fe2dbefc51465e3263a800a45c8e28491aba2f8bf280ed54a1abb7367', aspectPerItem=4 },
    ['meto'] = { ['dbHash'] = 'da8a0d6fe2dbefc51465e3263a800a45c8e28491aba2f8bf280ed54a1abb7367', aspectPerItem=4 },
    ['instrumentum']  = { ['dbHash'] = 'e1eb7f00c234839013ddef9f03229636d22de147adcf9fee626de1644fbf2c80', aspectPerItem=3 },
    ['machina']  = { ['dbHash'] = '3cb44f9b5008c88719725f87bf2cedc83a5d0307bb3650c66b7b43e03958cb31', aspectPerItem=1 },
    ['exanimis']  = { ['dbHash'] = '8b5883c60fb1e6cde2384682faae559a848a1e204b87b341149cffc960927199', aspectPerItem=4 },
    ['auram']  = { ['dbHash'] = '8b5883c60fb1e6cde2384682faae559a848a1e204b87b341149cffc960927199', aspectPerItem=4 },
    ['alienis']  = { ['dbHash'] = 'e6a2b5400b7df28b380a7bc8d3d829fd27bf62edd271ecf4aef61c144147ae9d', aspectPerItem=4 },
    ['fabrico']  = { ['dbHash'] = '157ce4ee77cbe7dac042945ff2f01d2fda26e8b32db981b8b5d8f5b90bc9b49d', aspectPerItem=4 },
    ['lux']  = { ['dbHash'] = '21be5ee78a5946ceea8d9e00a0b32946e68c6ffe0b2e06b305f6a883f3ef09c3', aspectPerItem=1 },
    ['herba']  = { ['dbHash'] = '16cede6115da3acb53ad9074b9f284f15d5c4a9be15549dc9c5020e2ef62d6d3', aspectPerItem=2 },
    ['praecantatio']  = { ['dbHash'] = '16cede6115da3acb53ad9074b9f284f15d5c4a9be15549dc9c5020e2ef62d6d3', aspectPerItem=2 },
    ['potentia']  = { ['dbHash'] = '8d2b26049f594ccaf34f830644652c981058b60f1434b8256e8304aeb5ec8fc2', aspectPerItem=4 },
    ['ignis']  = { ['dbHash'] = '8d2b26049f594ccaf34f830644652c981058b60f1434b8256e8304aeb5ec8fc2', aspectPerItem=4 },
    ['terra']  = { ['dbHash'] = '8f87afc6b6cc8cbb3d973c5a9fa0a0973d9c2c8e2727ec389b479252058dda4f', aspectPerItem=2 },
    ['perditio']  = { ['dbHash'] = '8f87afc6b6cc8cbb3d973c5a9fa0a0973d9c2c8e2727ec389b479252058dda4f', aspectPerItem=2 },
    ['messis']  = { ['dbHash'] = '8b106d64a741bd634abb3a79b7b0708f41094c87a7fd4d91120dff483c4d742d', aspectPerItem=3 },
    ['fames']  = { ['dbHash'] = '8b106d64a741bd634abb3a79b7b0708f41094c87a7fd4d91120dff483c4d742d', aspectPerItem=3 },
    ['permutatio']  = { ['dbHash'] = '8b106d64a741bd634abb3a79b7b0708f41094c87a7fd4d91120dff483c4d742d', aspectPerItem=3 }
}

local apiWrapper = 
{
    component = require("component")
}

local dictFactory = require("aspects-dictionary")
dictFactory.init(apiWrapper)

local dictionary = dictFactory.getDictionary(aspectsDict)
--[[
for k,v in pairs(aspectsDict) do
  local a,b,c,d,e,f = dictionary.getItemByAspect(k)
  print(k,a,b,c,d,e,f)
  io.read()
end
--]]

local loaderFactory = require("furnace-loader")
apiWrapper.aspectsDictionary = dictionary
loaderFactory.init(apiWrapper)

local sides = require("sides")
local component = apiWrapper.component
local interfaceAddress
for k,v in pairs(component.list()) do if v=="me_interface" then interfaceAddress=k end end
local transposerAddress
for k,v in pairs(component.list()) do if v=="transposer" then transposerAddress=k end end

local loader = loaderFactory.getLoader(interfaceAddress, transposerAddress, sides.east, sides.north)

local request = 
{
    [1]='permutatio',
    [2]='terra',
    [3]='praecantatio',
    [4]='perditio',
    [5]='fames'
}
loader.load(request, 10)