
require("awful.autofocus")
require("awful.remote")

local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")

do -- Handle runtime errors after startup
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened after startup!",
            text = tostring(err)
        })

        in_error = false
    end)
end



local function safe_restart ()
    awful.spawn.easy_async("awesome -k", function (_, _, _, exit_code)
        if exit_code == 0 then
            awesome.restart()
        else
            naughty.notify({
                preset = naughty.config.presets.critical,
                title = "BROKEN CONFIG",
                text = "awesome not restarted"
            })
        end
    end)
end

local terminal = "st -e nvim +term"
local modkey = "Mod1"
local winkey = "Mod4"

local move_direction = awful.client.focus.global_bydirection

-- {{{ Key bindings
local globalkeys = gears.table.join(
    -- Alt tab switches to most recent tag
    awful.key(
            -- [[
            -- So I need to be able to check if there is no tag in history to go to
            -- in that case I want it to go to another tag which has a client, also
            -- check for clients on tags on other screens
            --
            -- I need to be able to check if a tag has a client and if it doen't,
            -- either go to one that does or no op if there are no other tags with
            -- clients on any other screens
            --
            -- awful.client.focus.history.previous()
            -- I also want to be able to hold alt and hit tab repeatedly to scroll
            -- through history
            -- ]]
            --
        { modkey }, "Tab", awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),

    awful.key(
        { modkey }, "Return", function () awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }
    ),

    awful.key(
        { modkey }, "r", safe_restart,
        { description = "reload awesome", group = "awesome" }
    ),

    awful.key(
        { modkey, "Shift" }, "q", awesome.quit,
        { description = "quit awesome", group = "awesome" }
    ),

    awful.key(
        { modkey, "Shift" }, "b", function () awful.spawn("brave") end,
        { description = "launch brave", group = "launcher" }
    ),

    -- awful.key(
    --     { modkey }, "b", function () awful.spawn("vieb") end,
    --     { description = "launch vieb", group = "launcher" }
    -- ),

    awful.key(
    -- TODO: Add notifications
        { modkey }, "s",
        function ()
            awful.util.spawn(
                "scrot -e 'mv $f ~/.screenshots/ 2> /dev/null'",
                false
            )
        end,
        { description = "screenshot", group = "launcher" }
    ),

    awful.key(
        { modkey }, "h", function () move_direction("h") end,
        { description = "move client focus left", group = "client" }
    ),
    awful.key(
        { modkey }, "j", function () move_direction("j") end,
        { description = "move client focus down", group = "client" }
    ),
    awful.key(
        { modkey }, "k", function () move_direction("k") end,
        { description = "move client focus up", group = "client" }
    ),
    awful.key(
        { modkey }, "l", function () move_direction("l") end,
        { description = "move client focus right", group = "client" }
    ),

    awful.key(
        { modkey, "Shift" }, "h",
        function () awful.client.swap.global_bydirection("left") end,
        { description = "swap client with left", group = "client" }
    ),
    awful.key(
        { modkey, "Shift" }, "j",
        function () awful.client.swap.global_bydirection("down") end,
        { description = "swap client with down", group = "client" }
    ),
    awful.key(
        { modkey, "Shift" }, "k",
        function () awful.client.swap.global_bydirection("up") end,
        { description = "swap client with up", group = "client" }
    ),
    awful.key(
        { modkey, "Shift" }, "l",
        function () awful.client.swap.global_bydirection("right") end,
        { description = "swap client with right", group = "client" }
    )
)

local clientkeys = {
    -- Alt q to quit
    awful.key(
        { modkey }, "q",
        function (c) c:kill() end,
        { description = "close", group = "client" }
    )
}

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(

        globalkeys,

        -- View tag only.
        awful.key(
            { winkey }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            { description = "view tag #" .. i, group = "tag" }
        ),
        -- Move client to tag.
        awful.key(
            { winkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = "move focused client to tag #" .. i, group = "tag" }
        )
    )
end

-- Set keys
root.keys(globalkeys)


-- default settings
awful.layout.layouts = { awful.layout.suit.fair, }
naughty.config.defaults.ontop = true
awful.rules.rules = {
    { -- All clients will match this rule.
        rule = { },
        properties = {
            border_width = 0,
            size_hints_honor = false,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },
    {
        rule = { class = "Tor Browser" },
        properties = { floating = true }
    },
}

-- Init tags
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag(
        { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
        s, awful.layout.layouts[1]
    )
end)

-- Battery notification
local function low_battery ()

    -- Exits with 0 if < 10% and discharging
    local awk_script = [[
        acpi | awk '{
            gsub("%,", "", $4); print $4;
            exit ! ($4+0 <= 10 && $3 ~ /Discharging/)
        }'
    ]]

    awful.spawn.easy_async_with_shell(awk_script,
        function (stdout, _, _, exit_code)
            if exit_code ~= 0 then return end
            naughty.notify({
                preset = naughty.config.presets.critical,
                title = "LOW BATTERY " .. stdout,
                timeout = 15,
            })
        end
    )
end

local bat_timer = timer({ timeout = 60 * 5 })
bat_timer:connect_signal("timeout", low_battery)
bat_timer:start()

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- TODO: Handle adjusting of terminal font sizes
end)

-- Disabled to make you not rely on your mouse
-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

awful.spawn.with_shell("picom --backend=glx --no-fading-openclose --fade-in-step=1 --fade-out-step=1")
awful.spawn.with_shell("feh --bg-fill ~/.bg/frank.jpg") -- Hacky TODO Fix
-- awful.spawn.with_shell("st -e v")
