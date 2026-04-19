local wezterm = require('wezterm')
local utils = require('utils')
local sessionizer = wezterm.plugin.require("https://github.com/mikkasendke/sessionizer.wezterm")

local active_lookup = {}

function updateActiveMap()
    all_workspaces = wezterm.mux.get_workspace_names()
    active_lookup = utils:createLookupTable(all_workspaces)
    wezterm.log_info("update active map")
    return {}
end

-- Load ssh connections from ssh config
function sshGenerator()
    local schema = {}
    local ssh_hosts = wezterm.enumerate_ssh_hosts()
    local current = wezterm.mux.get_active_workspace()
    updateActiveMap()
    for host, config in pairs(ssh_hosts) do
        -- TODO maybe filter out some host
        if host == current then goto continue end
        table.insert(schema, { label = "ssh:" .. host, id = host })
        ::continue::
    end
    return schema
end

function isSshLabel(label)
    if not label then return false end
    if type(label) == "string" then
        return string.find(label, "^ssh:") ~= nil
    elseif type(label) == 'table' then
        return string.find(label.Text, "^ssh:") ~= nil
    end
end

local session_schema = {
    options = {
        callback = function(window, pane, id, label)
            if not id then return end
            if isSshLabel(label) then
                window:perform_action(wezterm.action.SwitchToWorkspace({
                    name = id,
                    spawn = {
                        args = { 'ssh', id },
                    }
                }), pane)
            else
                window:perform_action(wezterm.action.SwitchToWorkspace({name = id, spawn = { cwd = id } }), pane)
            end
            wezterm.log_info(window:active_tab():panes_with_info())
        end
    },

    sessionizer.DefaultWorkspace { label_overwrite = "🏠 Default" },
    sessionizer.AllActiveWorkspaces {},
    sshGenerator {},

    processing = {
        updateActiveMap,
        sessionizer.for_each_entry(function(entry) -- recolors labels and replaces the absolute path to the home directory with ~
            if active_lookup[entry.id] then
                entry.label = wezterm.format({
                    { Foreground = { Color = '#B0D767' } },
                    { Text = entry.label }
                })
            end
        end)
    }
}

local session_keys = {
    keys = {
        {
            key = 's', mods = 'CMD|SHIFT',
            action = sessionizer.show(session_schema)
        }
    }
}

return session_keys