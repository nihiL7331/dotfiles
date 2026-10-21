#define XWAYLAND 1

#include <stddef.h>
#include <X11/XF86keysym.h>

/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }
/* appearance */
static const int sloppyfocus               = 0;  /* focus follows mouse */
static const int bypass_surface_visibility = 0;  /* 1 means idle inhibitors will disable idle tracking even if it's surface isn't visible  */
static const unsigned int borderpx         = 1;  /* border pixel of windows */
static const float rootcolor[]             = COLOR(0x000000ff);
static const float bordercolor[]           = COLOR(0x00000000);
static const float focuscolor[]            = COLOR(0xE2231A88);
static const float urgentcolor[]           = COLOR(0xff0000ff);
/* This conforms to the xdg-protocol. Set the alpha to zero to restore the old behavior */
static const float fullscreen_bg[]         = {0.1f, 0.1f, 0.1f, 1.0f}; /* You can also use glsl colors */

static const char *const autostart[] = {
	"pipewire",                 				   				                                                   NULL,
	"wireplumber",              				   				                                                   NULL,
	"pipewire-pulse",           				   				                                                   NULL,
	"anyrun",         "daemon", 				   				                                                   NULL,
	"wbg",            "/home/nihil/repos/dotfiles/wallpapers/ascii-wallpaper.png",                                 NULL,
	"wl-paste",       "text",                                                      "--watch", "cliphist", "store", NULL,
	"kanshi",                                                                                                      NULL,
	NULL /* terminate */
};

/* tagging - TAGCOUNT must be no greater than 31 */
#define TAGCOUNT (5)

/* logging */
static int log_level = WLR_ERROR;

/* NOTE: ALWAYS keep a rule declared even if you don't use rules (e.g leave at least one example) */
static const Rule rules[] = {
	/* app_id             title       tags mask     isfloating   monitor */
	/* examples: */
	{ "Gimp_EXAMPLE",     NULL,       0,            1,           -1 }, /* Start on currently visible tags floating, not tiled */
	{ "firefox_EXAMPLE",  NULL,       1 << 8,       0,           -1 }, /* Start on ONLY tag "9" */
};

/* layout(s) */
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "",      tile },
	{ "",      NULL },    /* no layout function means floating behavior */
	{ "",      monocle },
};

/* monitors */
/* (x=-1, y=-1) is reserved as an "autoconfigure" monitor position indicator
 * WARNING: negative values other than (-1, -1) cause problems with Xwayland clients
 * https://gitlab.freedesktop.org/xorg/xserver/-/issues/899
*/
/* NOTE: ALWAYS add a fallback rule, even if you are completely sure it won't be used */
static const MonitorRule monrules[] = {
	/* name       mfact  nmaster scale layout       rotate/reflect                x    y */
	/* example of a HiDPI laptop monitor:
	{ "eDP-1",    0.5f,  1,      2,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,   -1,  -1 },
	*/
	/* defaults */
	{ NULL,       0.55f, 1,      1,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,   -1,  -1 },
};

/* keyboard */
static const struct xkb_rule_names xkb_rules = {
	/* can specify fields: rules, model, layout, variant, options */
	/* example:
	.options = "ctrl:nocaps",
	*/
	.options = NULL,
};

static const int repeat_rate = 25;
static const int repeat_delay = 600;

/* Trackpad */
static const int disable_touchpad = 1;
static const int tap_to_click = 1;
static const int tap_and_drag = 1;
static const int drag_lock = 1;
static const int natural_scrolling = 0;
static const int disable_while_typing = 1;
static const int left_handed = 0;
static const int middle_button_emulation = 0;
/* You can choose between:
LIBINPUT_CONFIG_SCROLL_NO_SCROLL
LIBINPUT_CONFIG_SCROLL_2FG
LIBINPUT_CONFIG_SCROLL_EDGE
LIBINPUT_CONFIG_SCROLL_ON_BUTTON_DOWN
*/
static const enum libinput_config_scroll_method scroll_method = LIBINPUT_CONFIG_SCROLL_2FG;

/* You can choose between:
LIBINPUT_CONFIG_CLICK_METHOD_NONE
LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS
LIBINPUT_CONFIG_CLICK_METHOD_CLICKFINGER
*/
static const enum libinput_config_click_method click_method = LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS;

/* You can choose between:
LIBINPUT_CONFIG_SEND_EVENTS_ENABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED_ON_EXTERNAL_MOUSE
*/
static const uint32_t send_events_mode = LIBINPUT_CONFIG_SEND_EVENTS_ENABLED;

/* You can choose between:
LIBINPUT_CONFIG_ACCEL_PROFILE_FLAT
LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE
*/
static const enum libinput_config_accel_profile accel_profile = LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE;
static const double accel_speed = 0.0;

/* You can choose between:
LIBINPUT_CONFIG_TAP_MAP_LRM -- 1/2/3 finger tap maps to left/right/middle
LIBINPUT_CONFIG_TAP_MAP_LMR -- 1/2/3 finger tap maps to left/middle/right
*/
static const enum libinput_config_tap_button_map button_map = LIBINPUT_CONFIG_TAP_MAP_LRM;

/* If you want to use the windows key for MODKEY, use WLR_MODIFIER_LOGO */
#define MODKEY WLR_MODIFIER_LOGO

#define TAGKEYS(KEY,SKEY,TAG) \
	{ MODKEY,                    KEY,            view,            {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL,  KEY,            toggleview,      {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_SHIFT, SKEY,           tag,             {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL|WLR_MODIFIER_SHIFT,SKEY,toggletag, {.ui = 1 << TAG} }

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { "/bin/zsh", "-c", cmd, NULL }

/* commands */
static const char *termcmd[]     = SHCMD("sfte");
// static const char *termcmd[]     = { "sfte",                                                          				                              NULL };
static const char *brupcmd[]     = { "sh",     "-c", "brightnessctl set 5%+ && kill -USR1 $(cat /tmp/dwlb.pid) 2>/dev/null",                      NULL };
static const char *brdowncmd[]   = { "sh",     "-c", "brightnessctl set 5%- && kill -USR1 $(cat /tmp/dwlb.pid) 2>/dev/null",                      NULL };
static const char *volmutecmd[]  = { "sh",     "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && kill -USR1 $(cat /tmp/dwlb.pid) 2>/dev/null", NULL };
static const char *volupcmd[]    = { "sh",     "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && kill -USR1 $(cat /tmp/dwlb.pid) 2>/dev/null",  NULL }; 
static const char *voldowncmd[]  = { "sh",     "-c", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && kill -USR1 $(cat /tmp/dwlb.pid) 2>/dev/null",  NULL }; 
static const char *anyruncmd[]   = { "anyrun",                                                        				                              NULL };
static const char *screencmd[]   = { "sh",     "-c", "grim -g \"$(slurp)\" - | wl-copy",                                                          NULL };
static const char *clipcmd[]     = { "sh",     "-c", "cliphist list | anyrun | cliphist decode | wl-copy",                                        NULL };

static const Key keys[] = {
	/* Note that Shift changes certain key codes: c -> C, 2 -> @, etc.  */
	/* modifier key                             function    argument          */
	{ 0,        XF86XK_MonBrightnessUp,         spawn,      {.v = brupcmd}    },
	{ 0,        XF86XK_MonBrightnessDown,       spawn,      {.v = brdowncmd}  },
	{ 0,        XF86XK_AudioMute,               spawn,      {.v = volmutecmd} },
	{ 0,        XF86XK_AudioLowerVolume,        spawn,      {.v = voldowncmd} },
	{ 0,        XF86XK_AudioRaiseVolume,        spawn,      {.v = volupcmd}   },
	{ 0,        XKB_KEY_Print,                  spawn,      {.v = screencmd}  },
	{ MODKEY,   XKB_KEY_space,                  spawn,      {.v = anyruncmd}  },
	{ MODKEY,   XKB_KEY_Return,                 spawn,      {.v = termcmd}    },
	{ MODKEY,   XKB_KEY_j,                      focusstack, {.i = +1}         },
	{ MODKEY,   XKB_KEY_k,                      focusstack, {.i = -1}         },
	{ MODKEY,   XKB_KEY_q,                      killclient, {0}               },
	{ MODKEY,   XKB_KEY_v,                      spawn,      {.v = clipcmd}    },
	TAGKEYS(    XKB_KEY_1, XKB_KEY_exclam,      0                             ),
	TAGKEYS(    XKB_KEY_2, XKB_KEY_at,          1                             ),
	TAGKEYS(    XKB_KEY_3, XKB_KEY_numbersign,  2                             ),
	TAGKEYS(    XKB_KEY_4, XKB_KEY_dollar,      3                             ),
	TAGKEYS(    XKB_KEY_5, XKB_KEY_percent,     4                             ),

#define CHVT(n) { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_XF86Switch_VT_##n, chvt, {.ui = (n)} }
	CHVT(1), CHVT(2), CHVT(3), CHVT(4), CHVT(5), CHVT(6),
	CHVT(7), CHVT(8), CHVT(9), CHVT(10), CHVT(11), CHVT(12),
};

static const Button buttons[] = {
	{ MODKEY, BTN_LEFT,   moveresize,     {.ui = CurMove} },
	{ MODKEY, BTN_MIDDLE, togglefloating, {0} },
	{ MODKEY, BTN_RIGHT,  moveresize,     {.ui = CurResize} },
};
