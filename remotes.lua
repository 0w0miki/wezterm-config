local wezterm = require('wezterm')
local remotes = {}
local sshs = {
    {
        -- This name identifies the domain
        name = 'remote-name',
        -- The hostname or address to connect to. Will be used to match settings
        -- from your ssh config file
        remote_address = 'remote-address',
        -- The username to use on the remote host
        username = 'user-name',
        -- The path to the wezterm binary on the remote host.
        -- Primarily useful if it isn't installed in the $PATH
        -- that is configure for ssh.
        remote_wezterm_path = "wezterm"
    }
}

remotes.ssh_domains = sshs

return remotes