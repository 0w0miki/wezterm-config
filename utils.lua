local wezterm = require 'wezterm'

local util = {}

function util:isMac()
    return wezterm.target_triple == 'x86_64-apple-darwin' or wezterm.target_triple == 'aarch64-apple-darwin'
end

function util:isWindows()
    return wezterm.target_triple == 'x86_64-pc-windows-msvc'
end

function util:isLinux()
    return wezterm.target_triple == 'x86_64-unknown-linux-gnu'
end

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
function util:basename(s)
    return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

-- Merge associative tables. If key conflicts, use t2
function util:mergeTable(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == 'table' and type(t1[k]) == 'table' then
            t1[k] = util:mergeTable(t1[k], t2[k])
        elseif type(v) ~= 'function' and type(v) ~= 'thread' then
            t1[k] = v
        end
    end

    return t1
end

-- Merge array to l1.
function util:mergeArray(l1, l2)
    for i, v in ipairs(l2) do
        table.insert(l1, v)
    end
    return l1
end

return util