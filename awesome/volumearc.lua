local awful = require("awful")
local beautiful = require("beautiful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local cairo = require("lgi").cairo
local color = require("gears.color")

GET_VOLUME_CMD = 'amixer -D pulse sget Master'
local INC_VOLUME_CMD = 'amixer -D pulse sset Master 5%+'
local DEC_VOLUME_CMD = 'amixer -D pulse sset Master 5%-'
local TOG_VOLUME_CMD = 'amixer -D pulse sset Master toggle'

local volumearc = wibox.widget {
    max_value = 255,
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

volumearc_widget = wibox.container.mirror(volumearc, { horizontal = true })

update_graphic = function(widget, stdout, _, _, _)
    local mute = string.match(stdout, "%[(o[nf]f?)%]")
    local volume = string.match(stdout, "(%d?%d?%d)%%")
    volume = tonumber(string.format("% 3d", volume))

    widget.value = volume;
    if mute == "off" then
        widget.colors = { "#606060" }--{ beautiful.widget_red }
    elseif volume >= 220 then
        widget.colors = { "#f08033" }
    elseif volume >= 170 then
        widget.colors = { "#c09033" }
    elseif volume >= 100 then
        widget.colors = { "#c0c033" }
    else
        widget.colors = { beautiful.widget_main_color }
    end
end

volumearc:connect_signal("button::press", function(_, _, _, button)
    if (button == 4) then awful.spawn(INC_VOLUME_CMD, false)
    elseif (button == 5) then awful.spawn(DEC_VOLUME_CMD, false)
    elseif (button == 1) then awful.spawn(TOG_VOLUME_CMD, false)
    end

    spawn.easy_async(GET_VOLUME_CMD, function(stdout, stderr, exitreason, exitcode)
        update_graphic(volumearc, stdout, stderr, exitreason, exitcode)
    end)
end)

watch(GET_VOLUME_CMD, 1, update_graphic, volumearc)
