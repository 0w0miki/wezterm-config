local wezterm = require('wezterm')
local util = require('utils')
local menu = require('launch')
local appearance = require('appearance')
local binding = require('binding')
local remotes = require('remotes')
local session_keys = require('session_manager')

local cmd_sender = wezterm.plugin.require("https://github.com/aureolebigben/wezterm-cmd-sender")

local config = {
    -- Launch Menu
    launch_menu = menu,

    scrollback_lines = 65535,
    -- quote_dropped_files = "Posix",

    -- Font
    font = wezterm.font_with_fallback({
        {
            family = 'MesloLGS NF',
            weight = 'DemiBold',
        },
        {
            family = "Hiragino Sans GB",
            weight = 'DemiBold',
        },
    }),

    quick_select_patterns = {
        -- match things that look like sha1 hashes
        -- (this is actually one of the default patterns)
        '[0-9a-f]{7,40}',
    },
}

config = util:mergeTable(config, appearance)
config = util:mergeTable(config, binding)
config = util:mergeTable(config, remotes)
config = util:mergeTable(config, session_keys)
-- config.keys = util:mergeArray(config.keys, session_keys)

cmd_sender.apply_to_config(config, {
    key = 'mapped:s',
    mods = 'ALT',
    description = 'Enter command to send to all panes of active tab'
})

return config