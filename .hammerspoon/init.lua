local start = hs.timer.absoluteTime()

-- Use 12x12 grid, which allows us to place on quarters, thirds and halves etc.
local width = 12
local height = 12

hs.grid.setGrid(width .. 'x' .. height)
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

hs.window.animationDuration = 0 -- disable animations

local reloader = require('reloader')
-- local zoom_detect = require("zoom_detect")
-- local mute_mic = require("mute_mic")
-- hs.loadSpoon("MicMute")

-- Forward function declarations.
local chain = nil

-- Returns a string specifing window location and dimensions on the grid of the
-- form:
--
--   "${x},${y} ${width}x${height}".
--
-- Example: "0,0 12x6" (represents a rectangle starting in the top-left,
-- occupying the full width of the screen and half the height.
local rect = function(x, y, w, h)
  return string.format('%d,%d %dx%d', x, y, w, h)
end

local grid = {
  full = {
    width = width,
    height = height,
  },
  half = {
    width = width / 2,
    height = height / 2,
  },
  third = {
    width = width / 3,
    height = height / 3,
  },
  quarter = {
    width = width / 4,
    height = height / 4,
  },
  sixth = {
    width = width / 6,
    height = height / 6,
  },
  twelth = {
    width = width / 12,
    height = height / 12,
  },
  two = {
    thirds = {
      width = 2 * width / 3,
      height = 2 * height / 3,
    },
  },
  three = {
    quarters = {
      width = 3 * width / 4,
      height = 3 * height / 4,
    },
  },
  five = {
    sixths = {
      width = 5 * width / 6,
      height = 5 * height / 6,
    },
  },
}
local placements = {
  centered = {
    full = rect(0, 0, grid.full.width, grid.full.height),
    huge = rect(grid.twelth.width, grid.twelth.height, grid.five.sixths.width, grid.five.sixths.height),
    big = rect(grid.sixth.width, grid.sixth.height, grid.two.thirds.width, grid.two.thirds.height),
    medium = rect(grid.quarter.width, grid.quarter.height, grid.half.width, grid.half.height),
    small = rect(grid.third.width, grid.third.height, grid.third.width, grid.third.height),
  },
  top = {
    half = rect(0, 0, grid.full.width, grid.half.height),
    third = rect(0, 0, grid.full.width, grid.third.height),
    quarter = rect(0, 0, grid.full.width, grid.quarter.height),
    two = {
      thirds = rect(0, 0, grid.full.width, grid.two.thirds.height),
    },
    three = {
      quarters = rect(0, 0, grid.full.width, grid.three.quarters.height),
    },
    left = rect(0, 0, grid.half.width, grid.half.height),
    right = rect(grid.half.width, 0, grid.half.width, grid.half.height),
  },
  right = {
    half = rect(grid.half.width, 0, grid.half.width, grid.full.height),
    third = rect(grid.two.thirds.width, 0, grid.third.width, grid.full.height),
    quarter = rect(grid.three.quarters.width, 0, grid.quarter.width, grid.full.height),
    two = {
      thirds = rect(grid.third.width, 0, grid.two.thirds.width, grid.full.height),
    },
    three = {
      quarters = rect(grid.quarter.width, 0, grid.three.quarters.width, grid.full.height),
    },
  },
  bottom = {
    half = rect(0, grid.half.height, grid.full.width, grid.half.height),
    third = rect(0, grid.two.thirds.height, grid.full.width, grid.third.height),
    quarter = rect(0, grid.three.quarters.height, grid.full.width, grid.quarter.height),
    two = {
      thirds = rect(0, grid.third.height, grid.full.width, grid.two.thirds.height),
    },
    three = {
      quarters = rect(0, grid.quarter.height, grid.full.width, grid.three.quarters.height),
    },
    left = rect(0, grid.half.height, grid.half.width, grid.half.height),
    right = rect(grid.half.width, grid.half.height, grid.half.width, grid.half.height),
  },
  left = {
    half = rect(0, 0, grid.half.width, grid.full.height),
    third = rect(0, 0, grid.third.width, grid.full.height),
    quarter = rect(0, 0, grid.quarter.width, grid.full.height),
    two = {
      thirds = rect(0, 0, grid.two.thirds.width, grid.full.height),
    },
    three = {
      quarters = rect(0, 0, grid.three.quarters.width, grid.full.height),
    },
  },
}

--
-- Utility and helper functions.
--
local lastSeenChain = nil
local lastSeenWindow = nil

-- Chain the specified movement commands.
--
-- This is like the "chain" feature in Slate, but with a couple of enhancements:
--
--  - Chains always start on the screen the window is currently on.
--  - A chain will be reset after 2 seconds of inactivity, or on switching from
--    one chain to another, or on switching from one app to another, or from one
--    window to another.
--
chain = function(movements)
  local chainResetInterval = 2 -- seconds
  local cycleLength = #movements
  local sequenceNumber = 1

  return function()
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local now = hs.timer.secondsSinceEpoch()
    local screen = win:screen()

    if lastSeenChain ~= movements or lastSeenAt < now - chainResetInterval or lastSeenWindow ~= id then
      sequenceNumber = 1
      lastSeenChain = movements
    elseif sequenceNumber == 1 then
      -- At end of chain, restart chain on next screen.
      screen = screen:next()
    end
    lastSeenAt = now
    lastSeenWindow = id

    hs.grid.set(win, movements[sequenceNumber], screen)
    sequenceNumber = sequenceNumber % cycleLength + 1
  end
end

--
-- Key bindings.
--

hs.hotkey.bind(
  { 'ctrl', 'alt' },
  'up',
  chain({
    placements.top.half,
    placements.top.third,
    placements.top.quarter,
    placements.top.three.quarters,
    placements.top.two.thirds,
  })
)

hs.hotkey.bind(
  -- { 'ctrl', 'alt' },
  { 'ctrl', 'alt', 'cmd' },
  'right',
  chain({
    placements.right.half,
    placements.right.third,
    placements.right.quarter,
    placements.right.three.quarters,
    placements.right.two.thirds,
  })
)

hs.hotkey.bind(
  { 'ctrl', 'alt' },
  'down',
  chain({
    placements.bottom.half,
    placements.bottom.third,
    placements.bottom.quarter,
    placements.bottom.three.quarters,
    placements.bottom.two.thirds,
  })
)

hs.hotkey.bind(
  -- { 'ctrl', 'alt' },
  { 'ctrl', 'alt', 'cmd' },
  'left',
  chain({
    placements.left.half,
    placements.left.third,
    placements.left.quarter,
    placements.left.three.quarters,
    placements.left.two.thirds,
  })
)

hs.hotkey.bind(
  { 'ctrl', 'alt', 'cmd' },
  'up',
  chain({
    placements.top.left,
    placements.top.right,
    placements.bottom.right,
    placements.bottom.left,
  })
)

hs.hotkey.bind(
  { 'ctrl', 'alt', 'cmd' },
  'down',
  chain({
    placements.centered.full,
    placements.centered.huge,
    placements.centered.big,
    placements.centered.medium,
    placements.centered.small,
  })
)
hs.hotkey.bind(
  { 'ctrl', 'alt', 'cmd' },
  'm',
  chain({
    placements.centered.full,
  })
)


reloader.init()

local elapsed = math.floor((hs.timer.absoluteTime() - start) / 1000000)
hs.notify.show('Hammerspoon', '', string.format('Initialized in %dms', elapsed))
