local wezterm = require('wezterm')
local util = require('utils')
local menu = require('launch')
local appearance = require('appearance')
local binding = require('binding')
local remotes = require('remotes')

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

wezterm.on(
    'gui-startup', function(cmd)
        local input_args = {}
        if cmd then
            input_args = cmd.args
        end

        -- Create a workspace for nsv connection in backend
        local nsvtab, nsvpane, nsvwindow = wezterm.mux.spawn_window {
            workspace = 'nsv',
            args = {},
        }
        nsvpane:split { direction = 'Top', size = 0.8 }

        local tab, pane, window = wezterm.mux.spawn_window {
            workspace = 'Default',
            args = input_args
        }
    end
)

config = util:mergeTable(config, appearance)
config = util:mergeTable(config, binding)
config = util:mergeTable(config, remotes)

return config