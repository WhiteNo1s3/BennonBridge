-- Procedural Smoke System
local Smoke = {}

local particles = {}

function Smoke.update(dt)
    for i = #particles, 1, -1 do
        local p = particles[i]
        p.y = p.y - p.speed * dt
        p.size = p.size + (p.growRate * dt)
        p.alpha = p.alpha - (p.fadeRate * dt)
        if p.alpha <= 0 then
            table.remove(particles, i)
        end
    end

    -- Spawn new particles occasionally
    if math.random() < 0.1 then
        table.insert(particles, {
            x = math.random(0, 1280), -- Virtual width
            y = 800,                  -- Bottom of virtual screen
            size = math.random(5, 15),
            speed = math.random(20, 60),
            growRate = math.random(2, 10),
            fadeRate = math.random(0.2, 0.8),
            alpha = 0.4
        })
    end
end

function Smoke.draw()
    for _, p in ipairs(particles) do
        love.graphics.setColor(0.8, 0.8, 0.8, p.alpha)
        love.graphics.circle("fill", p.x, p.y, p.size)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return Smoke