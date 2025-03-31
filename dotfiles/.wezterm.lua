-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font 'JetBrains Mono'
config.font_size = 12.0
config.enable_scroll_bar = true
config.audible_bell = "Disabled"

-- Fix missing title bar icons and inability to move the terminal
config.enable_wayland = false

return config
