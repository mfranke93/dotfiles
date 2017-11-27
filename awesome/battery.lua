local awful = require("awful")
local beautiful = require("beautiful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local cairo = require("lgi").cairo
local color = require("gears.color")

local BAT_CMD = 'cat /sys/class/power_supply/BAT0/capacity'
local PWR_CMD = 'cat /sys/class/power_supply/AC/online'

local batteryarc = wibox.widget {
    max_value = 1,
    thickness = 2,
    start_angle = 4.71238898, -- 2pi*3/4
    forced_height = 15,
    forced_width = 15,
    bg = "#ffffff11",
    paddings = 2,
    widget = wibox.container.arcchart,
    set_value = function(self, value)
        self.value = value
    end,
}

batteryarc_widget = wibox.container.mirror(batteryarc, { horizontal = true })

local update_graphic_bat = function(widget, stdout, _, _, _)
    local capa = tonumber(stdout)

    widget.value = capa / 100;
end

local update_graphic_ac = function(widget, stdout, _,_,_)
    local online = tonumber(stdout)
    if (online == 1) then
        widget.colors = { beautiful.widget_main_color }
    else
        widget.colors = { "#d0b040" }
    end
end

watch(BAT_CMD, 1, update_graphic_bat, batteryarc)
watch(PWR_CMD, 1, update_graphic_ac, batteryarc)
