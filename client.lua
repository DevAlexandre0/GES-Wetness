local wet = { level = 0.0, rain = 0, submerged = 0, lastUpdate = 0 }

local function clamp(x, a, b) if x < a then return a elseif x > b then return b else return x end end
local function isRaining() return GetRainLevel() > 0.01 or GetWeatherTypeTransition() == GetHashKey('RAIN') end
local function inWater()
  local ped = PlayerPedId()
  return IsPedSwimming(ped) or IsEntityInWater(ped)
end

CreateThread(function()
  while true do
    Wait(Config.TickMs)
    local dt = Config.TickMs / 1000.0
    local gain = 0.0
    wet.rain = isRaining() and 1 or 0
    wet.submerged = inWater() and 1 or 0

    if wet.submerged == 1 then
      gain = Config.WaterGain * dt
    elseif wet.rain == 1 then
      gain = Config.RainGain * dt
    else
      gain = -Config.DryRate * dt
    end

    wet.level = clamp(wet.level + gain, Config.ClampMin, Config.ClampMax)
    wet.lastUpdate = GetGameTimer()

    -- แจ้ง SurvCore (client) → จะ relay เป็น server event ges:wetness:changed
    TriggerEvent('ges:wetness:update', {
      level = wet.level, rain = wet.rain, submerged = wet.submerged
    })
  end
end)

local function getWetnessData() return wet end
exports('getWetnessData', getWetnessData)
