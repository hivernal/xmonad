import XMonad
import System.Exit

import XMonad.Actions.DwmPromote

import XMonad.Util.EZConfig
import XMonad.Util.WorkspaceCompare
import XMonad.Util.Cursor

import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders

import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.Place
import XMonad.Hooks.EwmhDesktops

myXmobarPP :: PP
myXmobarPP = def
    { ppCurrent         = xmobarColor "#fcfcfc" "#5c6667" . wrap " " " "
    , ppHidden          = xmobarColor "#fcfcfc" "" . wrap " " " "
		, ppHiddenNoWindows = xmobarColor "#5c6667" "" . wrap " " " "
    , ppSep             = " "
    , ppTitle           = xmobarColor "#fcfcfc" "" .shorten 50
    , ppLayout  = (\ x -> case x of
        "Spacing Tall"  -> "Tall"
        "Spacing Full"  -> "Full"
        _               -> x )
    }

-- myLayout = lessBorders OnlyFloat (smartSpacingWithEdge 5 (smartBorders tiled) ||| noBorders Full)
myLayout = lessBorders OnlyFloat (tiled |||  Full)
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1      -- Default number of windows in the master pane
    ratio   = 55/100    -- Default proportion of screen occupied by master pane
    delta   = 5/100  -- Percent of screen to increment by when resizing panes

myPlacement = fixed (0.5,0.5)

autostart :: X ()
autostart = do
  spawn "picom -b"
  -- spawn "lxpolkit &"
  spawn "feh --bg-fill ~/pictures/groot-dark.png"
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
  , normalBorderColor  = "#5e5f67"
  , focusedBorderColor = "#d2d9f8"
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
    , ("<XF86MonBrightnessUp>", spawn "/home/nikita/.config/hypr/brightness.sh up")
    , ("<XF86MonBrightnessDown>", spawn "/home/nikita/.config/hypr/brightness.sh down")
    -- , ("<XF86AudioLowerVolume>", spawn "amixer sset Master 5%-")
    -- , ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 5%+")
    , ("<XF86AudioLowerVolume>", spawn "/home/nikita/.config/hypr/volume.sh down")
    , ("<XF86AudioRaiseVolume>", spawn "/home/nikita/.config/hypr/volume.sh up")
    , ("<XF86AudioMute>", spawn "amixer sset Master toggle")
		, ("<Print>", spawn "flameshot gui")
		, ("M-<Return>", dwmpromote)
    ]
  `removeKeysP`

    [ "M-<Space>"
    ]
