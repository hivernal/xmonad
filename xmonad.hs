import XMonad
import System.Exit

import XMonad.Actions.DwmPromote

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.Loggers
import XMonad.Util.WorkspaceCompare
import XMonad.Util.Cursor

import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders 

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.Place
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks

myXmobarPP :: PP
myXmobarPP = def
    { ppCurrent         = xmobarColor "#fcfcfc" "#646870" . wrap " " " " 
    , ppHidden          = xmobarColor "#fcfcfc" "" . wrap " " " "
		, ppHiddenNoWindows = xmobarColor "#646870" "" . wrap " " " "
    , ppSep             = " "
    , ppTitle           = xmobarColor "#fcfcfc" "" .shorten 50
    , ppLayout  = (\ x -> case x of
        "Spacing Tall"  -> "Tall"
        "Spacing Full"  -> "Full"
        _               -> x )
    }

myLayout = lessBorders OnlyFloat (smartSpacingWithEdge 5 (smartBorders tiled) ||| noBorders Full)
-- myLayout = smartSpacingWithEdge 5 (smartBorders (withBorder 3 tiled)) |||  Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1      -- Default number of windows in the master pane
    ratio   = 55/100    -- Default proportion of screen occupied by master pane
    delta   = 5/100  -- Percent of screen to increment by when resizing panes

myPlacement = fixed (0.5,0.5)

autostart :: X ()
autostart = do
  -- spawn "picom -b"
  spawn "lxpolkit &"
  spawn "feh --bg-max /home/nikita/pictures/astronavt.jpg"
  setDefaultCursor xC_left_ptr

main :: IO ()
main = xmonad 
    . ewmhFullscreen
    . ewmh
    -- . setEwmhWorkspaceSort getSortByXineramaRule
    -- . withEasySB (statusBarProp "xmobar ~/.config/xmonad/xmobarrc.icons" (pure myXmobarPP)) defToggleStrutsKey
    . withEasySB (statusBarProp "polybar" (pure def)) defToggleStrutsKey
    $ myConfig 


myConfig = def
  { modMask = mod4Mask
  , layoutHook = myLayout
  , terminal = "alacritty"
  , borderWidth = 3
  , normalBorderColor  = "#282c34"
  , focusedBorderColor = "#fcfcfc"
  , manageHook = placeHook myPlacement <> manageHook def
  , startupHook = autostart
  }

  `additionalKeysP` 
    [ ("M-p", spawn "dmenu_run")
    , ("M-q", kill)
    , ("M-S-r", spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")
    , ("M-<Tab>", sendMessage NextLayout)
    , ("M-S-q", spawn "shutdown -h now")
    , ("M-S-e",  io exitSuccess)
    , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")
    , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
    -- , ("<XF86AudioLowerVolume>", spawn "amixer sset Master 5%-")
    -- , ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 5%+")
    , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ("<XF86AudioMute>", spawn "amixer sset Master toggle")
		, ("<Print>", spawn "flameshot gui")
		, ("M-<Return>", dwmpromote)
    ]
  `removeKeysP`

    [ "M-<Space>"
    ]
