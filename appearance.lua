local wezterm = require('wezterm')
local util = require('utils')

-- Define colors need to use
wezterm.log_info('Config Dir ' .. wezterm.config_dir)
local background = {
    {
        source = {
            Gradient = {
                orientation = { Linear = { angle = -45.0 } },
                colors = {'#ab72fd', '#3368b2' },
                interpolation = 'CatmullRom',
            },
        },
        hsb = { brightness = 0.4, },
        height = '100%',
        width = '100%',
        opacity = 0.9
    },
    {
        source = { Color = '#1f2430' },
        height = '100%',
        width = '100%',
        opacity = 0.6,
    },
    {
        source = {
            File = wezterm.config_dir .. '/101354890-lucy.png',
        },
        opacity = 0.1,
        vertical_align = 'Bottom',
        horizontal_align = 'Right',
        repeat_x = 'NoRepeat',
        repeat_y = 'NoRepeat',
        height = '25cell',
        width = '41cell'
    },
}

local appearance = {}

local general = {
    color_scheme = "Ayu Mirage",

    window_decorations = "RESIZE",

    -- NOTE - Now there is only one scroll bar for all panes
    -- Just enable it to see whether there is some context above
    enable_scroll_bar = true,
    min_scroll_bar_height = '2cell',

    background = background,

    -- Visual Bell
    visual_bell = {
        fade_in_function = 'EaseIn',
        fade_in_duration_ms = 100,
        fade_out_function = 'EaseOut',
        fade_out_duration_ms = 100,
        target = 'CursorColor',
    },
    colors = {
        visual_bell = '#e6505f',
        scrollbar_thumb = '#e6505f',
        selection_bg = '#963694',
    },

    -- Inactive pane
    inactive_pane_hsb = {
        saturation = 0.5,
        brightness = 0.4,
    },
}

-- Tab
local tab_config = {
    use_fancy_tab_bar = true,
    window_frame = {
        font = wezterm.font { family = 'Iosevka', weight = 'Bold'},
        font_size = 12.5,
        active_titlebar_bg = '#000000',
        inactive_titlebar_bg = '#000000',
    },
    colors = {
        tab_bar = {
        -- The color of the strip that goes along the top of the window
        -- (does not apply when fancy tab bar is in use)
            background = '#0b0022',
            -- The active tab is the one that has focus in the window
            active_tab = {
                -- The color of the background area for the tab
                bg_color = '#ab72fd',
                -- The color of the text for the tab
                fg_color = '#e0e0e0',
            },
            inactive_tab = {
                bg_color = '#000000',
                fg_color = '#808080',
            },
            inactive_tab_hover = {
                bg_color = '#574962',
                fg_color = '#909090',
            },
            new_tab = {
                bg_color = '#000000',
                fg_color = '#808080',
            },
            new_tab_hover = {
                bg_color = '#574962',
                fg_color = '#909090',
            },
        },
    },
}

-- Status
wezterm.on(
    'update-status', function(window, pane)
        local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
        local status = {
            right = {},
            left = {},
        }
        local right_num_ele = 1
        local left_num_ele = 1
        local colors = {
            -- '#4b3a67',
            -- '#52307c',
            -- '#663a82',
            -- '#7c5295',
            -- '#b491c8',

            '#4a86d9',
            '#2dacc4',
            '#9fd1ac',
            '#ab72fd',
            '#ace7ed',

            '#eddff1',
            '#d4e4fd',

        }
        local text_fg = '#e0e0e0'

        function pushRightStatus(text, bg, fg)
            table.insert(status["right"], { Foreground = { Color = bg } })
            table.insert(status["right"], { Text = SOLID_LEFT_ARROW })
            table.insert(status["right"], { Foreground = { Color = fg } })
            table.insert(status["right"], { Background = { Color = bg } })
            table.insert(status["right"], { Text = ' ' .. text .. ' ' })
            right_num_ele = right_num_ele + 1
        end


        function pushLeftStatus(text, bg, fg)
            -- table.insert(status["left"], { Foreground = { Color = bg } })
            -- table.insert(status["left"], { Text = SOLID_LEFT_ARROW })
            table.insert(status["left"], { Foreground = { Color = fg } })
            table.insert(status["left"], { Background = { Color = bg } })
            table.insert(status["left"], { Text = ' ' .. text .. ' ' })
            right_num_ele = right_num_ele + 1
        end

        -- process
        local proc = pane:get_foreground_process_info().argv
        -- pushRightStatus(util:basename((table.concat(proc, ' '))), colors[right_num_ele], text_fg)
        pushRightStatus(util:basename(table.concat(proc, ' ')), colors[right_num_ele], text_fg)

        -- workspace
        local workspace = window:active_workspace()
        pushRightStatus(workspace, colors[right_num_ele], text_fg)

        -- Date in this style: "Wed 03-03"
        local date = wezterm.strftime '%m-%d %H:%M'
        pushRightStatus(date, colors[right_num_ele], text_fg)

        -- An entry for each battery (typically 0 or 1 battery)
        for _, b in ipairs(wezterm.battery_info()) do
            local batery = b.state_of_charge * 100
            if batery < 20 then
                pushRightStatus(string.format('%.0f%%', batery), colors[right_num_ele], '#fa450e')
            else
                pushRightStatus(string.format('%.0f%%', batery), colors[right_num_ele], text_fg)
            end
        end

        -- left moon
        pushLeftStatus("🌕", 'black', 'yellow')

        -- Put status
        window:set_left_status(wezterm.format(status["left"]))
        window:set_right_status(wezterm.format(status["right"]))
    end
)

-- Tab title
wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        if tab.is_active then
            return ' ' .. tab.active_pane.title .. ' '
        end
        local has_unseen_output = false
        for _, pane in ipairs(tab.panes) do
            if pane.has_unseen_output then
                has_unseen_output = true
                break
            end
        end

        -- unseen output on inactive tab
        if has_unseen_output then
            return {
                { Foreground = { Color = 'Orange' } },
                { Text = ' ' .. tab.active_pane.title .. ' ' },
            }
        end
        return tab.active_pane.title
    end
)

appearance = util:mergeTable(appearance, general)
appearance = util:mergeTable(appearance, tab_config)
return appearance