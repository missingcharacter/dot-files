-- Pull in the wezterm API
local wezterm = require("wezterm")
-- Helper for defining key assignment actions in your configuration file
--local act = wezterm.action
-- Module exposes functions that operate on the multiplexer layer
local mux = wezterm.mux
-- This will hold the configuration.
local config = wezterm.config_builder()

-- If you don't want the default assignments to be registered,
-- you can disable all of them with this configuration;
-- if you chose to do this, you must explicitly register
-- every binding.
--config.disable_default_mouse_bindings = true
--config.mouse_bindings = {
--  -- Change the default click behavior so that it only selects
--  -- text and doesn't open hyperlinks
--  {
--    event = { Up = { streak = 1, button = 'Left' } },
--    mods = 'NONE',
--    action = act.CompleteSelection 'ClipboardAndPrimarySelection',
--  },
--  -- and make CTRL-Click open hyperlinks
--  {
--    event = { Up = { streak = 1, button = 'Left' } },
--    mods = 'CTRL',
--    action = act.OpenLinkAtMouseCursor,
--  },
--  -- Scrolling up while holding CTRL increases the font size
--  {
--    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
--    mods = 'CTRL',
--    action = act.IncreaseFontSize,
--  },
--  -- Scrolling down while holding CTRL decreases the font size
--  {
--    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
--    mods = 'CTRL',
--    action = act.DecreaseFontSize,
--  },
--}

wezterm.on("gui-startup", function(cmd)
    local _, _, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

-- This is where you actually apply your config choices
config.font_size = 15.0
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.window_background_opacity = 0.9
config.default_cursor_style = "BlinkingBlock"
-- For example, changing the color scheme:
config.color_scheme = "Dracula"

-- and finally, return the configuration to wezterm
return config
