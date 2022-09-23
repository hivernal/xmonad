import XMonad
import System.Exit

import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.Loggers

import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.Place
import XMonad.Hooks.EwmhDesktops


myXmobarPP :: PP
myXmobarPP = def
    { ppCurrent         = xmobarColor "#fcfcfc" "#646870" . wrap " " " " 
    , ppHidden          = xmobarColor "#fcfcfc" "" . wrap " " " "
		, ppHiddenNoWindows = xmobarColor "#646870" "" . wrap " " " "
    , ppSep             = " "
    , ppTitle           = xmobarColor "#fcfcfc" "" .shorten 55
    , ppOrder           = \[ws, _, t] -> [ws, t]
    }

myLayout = smartBorders (withBorder 3 tiled) ||| noBorders Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1      -- Default number of windows in the master pane
    ratio   = 55/100    -- Default proportion of screen occupied by master pane
    delta   = 5/100  -- Percent of screen to increment by when resizing panes

myPlacement = fixed (0.5,0.5)


main :: IO ()
main = xmonad 
    . ewmhFullscreen
    . ewmh
    . withEasySB (statusBarProp "xmobar ~/.config/xmonad/xmobarrc.icons" (pure myXmobarPP)) defToggleStrutsKey
    $ myConfig 


myConfig = def
  { modMask = mod4Mask
  , layoutHook = spacingRaw False (Border 10 10 10 10) True (Border 10 10 10 10) True $ myLayout
  , terminal = "alacritty"
  ,  borderWidth = 0
  ,  normalBorderColor  = "#282c34"
  ,  focusedBorderColor = "#fcfcfc"
  ,  manageHook = placeHook myPlacement <> manageHook def
  }

  `additionalKeysP` 
    [ ("M-p", spawn "dmenu_run -nf '#fcfcfc' -nb '#282c34' -sb '#646870' -sf '#fcfcfc' -fn 'JetBrainsMonoMedium Nerd Font-13'")
    , ("M-q", kill)
    , ("M-S-r", spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")
    , ("M-<Tab>", sendMessage NextLayout)
    , ("M-S-q", spawn "shutdown -h now")
    , ("M-S-e",  io exitSuccess)
    , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 5")
    , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
    , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
    , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
    , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
		, ("<Print>", spawn "flameshot gui")
    ]
  `removeKeysP`

    [ "M-<Space>"
    ]
