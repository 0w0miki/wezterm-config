local wezterm = require('wezterm')
local uitl = require('utils')
local config = {}

local key_binding = {
    keys = {
        {
            key = 'd', mods = 'CMD',
            action = wezterm.action.SplitPane {
                direction = 'Right',
                size = { Percent = 50 },
            }
        },
        {
            key = 'd', mods = 'CMD|SHIFT',
            action = wezterm.action.SplitPane {
                direction = 'Down',
                size = { Percent = 50 },
            }
        },
        {
            key = 'p', mods = 'CMD|SHIFT',
            action = wezterm.action.ShowLauncherArgs { flags = 'LAUNCH_MENU_ITEMS|WORKSPACES' }
        },
        {
            key = 't', mods = 'CMD|SHIFT',
            action = wezterm.action.ShowLauncherArgs { flags = 'TABS' }
        },
        {
            key = 'w', mods = 'CMD',
            action = wezterm.action.CloseCurrentPane { confirm = true },
        },
        {
            key = 'w', mods = 'CMD|SHIFT',
            action = wezterm.action.CloseCurrentTab { confirm = true },
        },
        {
            key = 'p', mods = 'CMD|OPT|SHIFT|CTRL',
            action = wezterm.action.PaneSelect
        },
        {
            key = 'LeftArrow', mods = 'CMD|OPT|SHIFT|CTRL',
            action = wezterm.action.ActivatePaneDirection 'Left',
        },
        {
            key = 'RightArrow', mods = 'CMD|OPT|SHIFT|CTRL',
            action = wezterm.action.ActivatePaneDirection 'Right',
        },
        {
            key = 'UpArrow', mods = 'CMD|OPT|SHIFT|CTRL',
            action = wezterm.action.ActivatePaneDirection 'Up',
        },
        {
            key = 'DownArrow', mods = 'CMD|OPT|SHIFT|CTRL',
            action = wezterm.action.ActivatePaneDirection 'Down',
        },
        {
            key = 'h', mods = 'CMD|OPT|SHIFT|CTRL',
            action = wezterm.action.ActivatePaneDirection 'Left',
        },
        {
            key = 'l', mods = 'CMD|OPT|SHIFT|CTRL',
            action = wezterm.action.ActivatePaneDirection 'Right',
        },
        {
            key = 'k', mods = 'CMD|OPT|SHIFT|CTRL',
            action = wezterm.action.ActivatePaneDirection 'Up',
        },
        {
            key = 'j', mods = 'CMD|OPT|SHIFT|CTRL',
            action = wezterm.action.ActivatePaneDirection 'Down',
        },
        {
            key = '[', mods = 'CMD',
            action = wezterm.action.ActivatePaneDirection "Prev"
        },
        {
            key = ']', mods = 'CMD',
            action = wezterm.action.ActivatePaneDirection "Next"
        },
        {
            -- search for things that look like git hashes
            key = 'H', mods = 'SHIFT|CTRL',
            action = wezterm.action.Search { Regex = '[a-f0-9]{6,}' },
        },
        {
            key = 'LeftArrow', mods = 'OPT',
            action = wezterm.action.SendKey { key = 'b', mods = 'OPT' },
        },
        {
            key = 'RightArrow', mods = 'OPT',
            action = wezterm.action.SendKey { key = 'f', mods = 'OPT' },
        },
        {
            key = 'Space', mods = 'CMD|SHIFT',
            action = wezterm.action.QuickSelect,
        },
        {
            key = '`', mods = 'CTRL',
            action = wezterm.action.SwitchWorkspaceRelative(1),
        },
    },
}

local key_tables = {
    key_tables = {}
}

-- Search
local search_mode = {
    { key = 'F3', mods = 'NONE', action = wezterm.action.CopyMode 'NextMatch' },
    { key = 'F3', mods = 'SHIFT', action = wezterm.action.CopyMode 'PriorMatch' },
    { key = 'Enter', mods = 'NONE', action = wezterm.action.CopyMode 'NextMatch' },
    { key = 'Enter', mods = 'SHIFT', action = wezterm.action.CopyMode 'PriorMatch' },
}
if wezterm.gui then
    local default_search_key = wezterm.gui.default_key_tables().search_mode
    search_mode = uitl:mergeArray(default_search_key, search_mode)
    key_tables["key_tables"]["search_mode"] = search_mode
end

local mouse_binding = {
    mouse_bindings = {
        -- Change the default click behavior so that it only selects
        -- text and doesn't open hyperlinks
        {
            event = { Up = { streak = 1, button = 'Left' } }, mods = 'NONE',
            action = wezterm.action.CompleteSelection 'ClipboardAndPrimarySelection',
        },
        -- and make CTRL-Click open hyperlinks
        {
            event = { Up = { streak = 1, button = 'Left' } }, mods = 'CMD',
            action = wezterm.action.OpenLinkAtMouseCursor,
        },
        -- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
        {
            event = { Down = { streak = 1, button = 'Left' } },
            mods = 'CMD',
            action = wezterm.action.Nop,
        },
        {
            event = { Up = { streak = 1, button = 'Right' } }, mods = 'NONE',
            action = wezterm.action.PasteFrom 'Clipboard',
        }
    }
}

key_binding = uitl:mergeTable(config, key_binding)
key_binding = uitl:mergeTable(config, key_tables)
key_binding = uitl:mergeTable(config, mouse_binding)

return key_binding