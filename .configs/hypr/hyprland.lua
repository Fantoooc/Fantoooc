--------------------
----  MONITORS  ----
--------------------

hl.monitor({
    output   = "DP-1",
    mode     = "1920x1080@180",
    position = "0x0",
    scale    = "1.0"
})

--------------------
----  PROGRAMS  ----
--------------------

local terminal    = "alacritty"
local fileManager = "pcmanfm"
local ipc         = "noctalia msg"

---------------------
----  AUTOSTART  ----
---------------------

hl.on("hyprland.start", function()
	-- hl.exec_cmd("pipewire")
	-- hl.exec_cmd("wireplumber")
	-- hl.exec_cmd("pipewire-pulse")
  hl.exec_cmd("/usr/lib/hyprpolkitagent")
	hl.exec_cmd("/usr/bin/artix-pipewire-launcher")
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic-Hypr 24")
  hl.exec_cmd("hyprpm reload")
	hl.exec_cmd("hyprlock -q")
	hl.exec_cmd("noctalia")
end)

---------------------------------
----  ENVIRONMENT VARIABLES  ----
---------------------------------

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE",    "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("HYPRSHOT_DIR",        os.getenv("HOME") .. "/Pictures/screenshots")

hl.env("XCURSOR_THEME",    "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic-Hypr")
hl.env("XCURSOR_SIZE",     "24")
hl.env("HYPRCURSOR_SIZE",  "24")

hl.env("GBM_BACKEND",                  "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME",    "nvidia")
hl.env("LIBVA_DRIVER_NAME",            "nvidia")
-- hl.env("__GL_GSYNC_ALLOWED",           "0")
-- hl.env("__GL_VRR_ALLOWED",             "0")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("NVD_BACKEND",                  "direct")

-- hl.env("QT_AUTO_SCREEN_SCALE_FACTOR",         "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_QPA_PLATFORMTHEME",                "gtk3")

hl.env("GDK_BACKEND",     "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland,x11")
hl.env("CLUTTER_BACKEND", "wayland")

-----------------------
----  PERMISSIONS  ----
-----------------------

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 2,
        gaps_out = 3,

        border_size = 0,
        col = {
            active_border   = "rgba(00000000)",
            inactive_border = "rgba(00000000)"
        },

        resize_on_border = false,
        -- extend_border_grab_area = 15,

        layout = "dwindle"
    },

    binds = {
        drag_center_window = false
    },

    decoration = {
        rounding       = 8, --10
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        border_part_of_window = true,

        shadow = {
            enabled        = true,
            range          = 15,
            render_power   = 3,
            color          = 0x40000000,
            color_inactive = 0x18000000,
            offset         = {0, 0}
        },

        blur = {
            enabled   = true,
            size      = 5,
            passes    = 3,

            noise      = 0.005,
            contrast   = 0.900,
            brightness = 0.850,
            vibrancy   = 0.169,

            special = false,
            popups  = true,
            -- popups_ignorealpha = 0.2
        }
    },

    dwindle = { preserve_split = true },

    animations = { enabled = true },

    ecosystem = { no_donation_nag = true }
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.curve("easy",           { type = "spring", mass = 0.6, stiffness = 2400, dampening = 60 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsMove",   enabled = true,  speed = 1.35, bezier = "quick" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 0.33, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 0.45, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 0.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = false, speed = 0.01, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = false, speed = 0.16, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper    = 0,
        disable_hyprland_logo      = true,
        disable_splash_rendering   = true,
        -- mouse_move_enables_dpms    = true,
        key_press_enables_dpms     = true,
        disable_autoreload         = true,
        close_special_on_empty     = true,
        -- initial_workspace_tracking = 2,
        middle_click_paste         = false
    }
})

-----------------
----  INPUT  ----
-----------------

hl.config({
    input = {
        kb_layout  = "us,ru",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:alt_shift_toggle, caps:none",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0,

        touchpad = { natural_scroll = false }
    },
    cursor = {
        inactive_timeout    = 5,
        no_hardware_cursors = 0
    }
})

-----------------------
----  KEYBINDINGS  ----
-----------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal), { repeating = true })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))

hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -qla"))
hl.bind(mainMod .. " + TAB + S",   hl.dsp.exec_cmd("pkill slurp || hyprshot -zm region -s"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("pkill slurp || hyprshot -zm region --clipboard-only -s"))
hl.bind("Print",   hl.dsp.exec_cmd("hyprshot -m output -m active --clipboard-only -s"))

hl.bind(mainMod .. " + R",         hl.dsp.exec_cmd(ipc .. " panel-toggle launcher"))
hl.bind(mainMod .. " + V",         hl.dsp.exec_cmd(ipc .. " panel-toggle clipboard"))
hl.bind("ALT + TAB",               hl.dsp.exec_cmd(ipc .. " window-switcher"))
hl.bind(mainMod .. " + SHIFT + ESCAPE",    hl.dsp.exec_cmd(ipc .. " panel-toggle session"))

hl.bind(mainMod .. " + C",   hl.dsp.window.close())
hl.bind(mainMod .. " + F",   hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + up",  hl.dsp.window.fullscreen({ mode="maximized", action = "toggle" }))
hl.bind("F11", hl.dsp.window.fullscreen({ mode="fullscreen", action = "toggle" }))
-- hl.bind(mainMod .. " + mouse:275", hl.dsp.layout("splitratio +0.1"))
-- hl.bind(mainMod .. " + mouse:276", hl.dsp.layout("splitratio -0.1"))
hl.bind(mainMod .. " + SHIFT + code:49", hl.dsp.layout("togglesplit"))
-- hl.bind(mainMod .. " + SHIFT + mouse:275", hl.dsp.layout("togglesplit"))
-- hl.bind(mainMod .. " + SHIFT + mouse:276", hl.dsp.layout("togglesplit"))

-- hl.bind(mainMod .. " + D", hl.dsp.focus({ workspace = "name:empty" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ workspace = "r+1" }), { repeating = true })
hl.bind(mainMod .. " + left",  hl.dsp.focus({ workspace = "r-1" }), { repeating = true })
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_down",   hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "r+1" }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ workspace = "r-1" }), { repeating = true })

for i = 1, 10 do
    hl.bind(mainMod .. " + " .. i % 10,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. i % 10,     hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + Q",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-----------------------
----  LAYER RULES  ----
-----------------------

hl.layer_rule({
    name = "noctalia",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$"
    },
    no_anim = true,
    -- ignore_alpha = 0.5,
    -- blur = true,
    -- blur_popups = true
})

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize"
})
-- suppressMaximizeRule:set_enabled(false)

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true
})

hl.window_rule({
    name = "noctalia",
    match = { class = "dev.noctalia.Noctalia" },
    -- ["hyprbars:no_bar"] = true,
    float = true,
    size = { 1280, 920 }
})

hl.window_rule({
    name  = "steam",
    match = { class = "steam" },
    -- ["hyprbars:no_bar"] = true
})

-- hl.window_rule({ match = { workspace = "w[tv1]", float = false }, border_size = 1 })

hl.window_rule({
    name   = "terminal",
    match  = { class = "Alacritty" },
    float  = true,
    center = true,
    size   = { 820, 460 }
})

hl.window_rule({
    name   = "multimc",
    match  = { class = "MultiMC", title = "^MultiMC 5 — .*" },
    float  = true,
    center = true,
    size   = { 1080, 580 }
})

hl.window_rule({
    name = "pcmanfm",
    match = { class = "^pcmanfm$" },
    float = true,
    center = true,
    size = { 1020, 580 }
})

for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "DP-1", persistent = true })
end

--[[
hl.config({
    plugin = {
        hyprbars = {
            bar_height         = 27,
            bar_color          = 0xab131313,
            bar_blur           = true,
            bar_padding        = 5,
            bar_button_padding = 5,
            icon_on_hover      = false,

            bar_part_of_window         = true,
            bar_precedence_over_border = true,

            bar_title_enabled     = false,
            bar_text_size         = 10,
            bar_text_font         = "JetBrains Mono Extrabold",
            bar_text_align        = center,
            ["col.text"]          = 0xff81a1c1, -- "rgb(129, 161, 193)",
            bar_buttons_alignment = right,

            -- on_double_click = "hyprctl dispatch 'hl.dsp.window.fullscreen({ mode=\"maximized\", action = \"toggle\" })'"
        }
    }
})

hl.plugin.hyprbars.add_button({
    bg_color = "rgb(cc241d)",
    fg_color = "rgb(cc241d)",
    size     = 15,
    icon     = "",
    action   = "hyprctl dispatch 'hl.dsp.window.close()'"
})

hl.plugin.hyprbars.add_button({
    bg_color = "rgb(d79921)",
    fg_color = "rgb(d79921)",
    size     = 15,
    icon     = "",
    action   = "hyprctl dispatch 'hl.dsp.window.fullscreen({ mode=\"maximized\", action = \"toggle\" })'"
})

hl.plugin.hyprbars.add_button({
    bg_color = "rgb(98971a)",
    fg_color = "rgb(98971a)",
    size     = 15,
    icon     = "",
    action   = "hyprctl dispatch 'hl.dsp.window.float({ action = \"toggle\" })'"
})

hl.plugin.hyprbars.add_button({
    bg_color = "rgb(689d6a)",
    fg_color = "rgb(689d6a)",
    size     = 15,
    icon     = "",
    action   = "hyprctl dispatch 'hl.dsp.window.pin()'"
})
]]
