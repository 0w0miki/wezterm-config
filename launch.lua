local wezterm = require 'wezterm'
local util = require('utils')

local launch_menu = {}

if util:isLinux() then
    table.insert(launch_menu, {
        args = { 'htop' }
    })
end

if util:isMac() then
    table.insert(launch_menu, {
        label = 'htop',
        args = { '/opt/homebrew/bin/htop' }
    })
end

if util:isMac() then
    table.insert(launch_menu, {
        label = 'zsh',
        args = { 'zsh', '-l' }
    })
end

if util:isMac() or util:isLinux() then
    table.insert(launch_menu, {
        label = 'Bash',
        args = { 'bash', '-l' }
    })
end

return launch_menu