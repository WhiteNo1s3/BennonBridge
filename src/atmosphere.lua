-- Atmosphere Controller: Handles Time of Day and Visual Mood
local Atmosphere = {}

local time_settings = {
    morning = { color = {0.95, 0.85, 0.6}, tint = 0.2 },
    day     = { color = {1.0, 1.0, 1.0}, tint = 0.0 },
    evening = { color = {0.8, 0.5, 0.4}, tint = 0.3 },
    night   = { color = {0.2, 0.2, 0.4}, tint = 0.5 }
}

function Atmosphere.getCurrentMood()
    local hour = os.date("*t").hour
    if hour >= 5 and hour < 10 then return time_settings.morning end
    if hour >= 10 and hour < 17 then return time_settings.day end
    if hour >= 17 and hour < 21 then return time_settings.evening end
    return time_settings.night
end

function Atmosphere.applyMood()
    local mood = Atmosphere.getCurrentMood()
    love.graphics.setColor(mood.color[1], mood.color[2], mood.color[3], mood.tint)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1, 1) -- Reset for other drawings
end

return Atmosphere