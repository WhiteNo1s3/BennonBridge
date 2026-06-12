-- Virtual-resolution viewport
--
-- The whole game is laid out in a fixed 1280x800 virtual space. This module
-- maps that virtual space to whatever window size LÖVE is currently in,
-- preserving aspect ratio (letterboxed). Drawing code just uses virtual
-- coords; mouse coords from love callbacks are converted with toVirtual().
--
-- Resulting behaviour: window is freely resizable and the game scales
-- crisply at any size, like Balatro.

local C = require("src.constants")

local V = {}

-- Base virtual canvas (safe content area — all game elements fit here)
V.W       = C.SW       -- virtual width  (1280)
V.H       = C.SH       -- virtual height (800)
V.scale   = 1
V.offsetX = 0
V.offsetY = 0

-- Full virtual screen extents — always fills the physical window.
-- Use these for backgrounds so no black bars appear around the felt.
V.VX = 0      -- virtual x of window top-left  (0 or negative)
V.VY = 0      -- virtual y of window top-left  (0 or negative)
V.VW = C.SW   -- virtual width  of window  (>= V.W)
V.VH = C.SH   -- virtual height of window  (>= V.H)

function V.update()
    local winW, winH = love.graphics.getDimensions()
    local sx = winW / V.W
    local sy = winH / V.H

    -- Use the SMALLER scale so the full safe area (1280×800) is always visible.
    -- backgrounds are drawn to V.VX/VY/VW/VH so the felt fills the screen.
    V.scale = math.min(sx, sy)

    V.offsetX = (winW - V.W * V.scale) / 2
    V.offsetY = (winH - V.H * V.scale) / 2

    -- Full-screen virtual extents (may extend beyond the 1280×800 safe area)
    V.VX = -V.offsetX / V.scale
    V.VY = -V.offsetY / V.scale
    V.VW =  winW / V.scale
    V.VH =  winH / V.scale
end

-- Begin drawing transform: call once at the top of love.draw, before
-- anything else. drawEnd() must be called at the end of love.draw.
function V.drawBegin()
    love.graphics.push()
    love.graphics.translate(V.offsetX, V.offsetY)
    love.graphics.scale(V.scale, V.scale)
end

function V.drawEnd()
    love.graphics.pop()
    -- No letterbox bars needed: render code fills backgrounds to V.VX/VY/VW/VH.
end

-- Convert a window coordinate (from love.mouse*) into virtual space.
function V.toVirtual(x, y)
    return (x - V.offsetX) / V.scale,
           (y - V.offsetY) / V.scale
end

function V.mouseVirtual()
    local x, y = love.mouse.getPosition()
    return V.toVirtual(x, y)
end

return V
