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
import XMonad.ManageHook

myXmobarPP :: PP
myXmobarPP = def
    { ppCurrent         = xmobarColor "#d2d9f8" "#5e5f67" . pad
    , ppHidden          = xmobarColor "#d2d9f8" "" . pad
		, ppHiddenNoWindows = xmobarColor "#5e5f67" "" . pad
    , ppSep             = " "
    , ppWsSep           = " "
    , ppTitle           = xmobarColor "#d2d9f8" "" .shorten 50
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
  -- spawn "picom -b"
  -- spawn "lxpolkit &"
  spawn "feh --bg-fill ~/pictures/neboskreb.jpg"
  setDefaultCursor xC_left_ptr

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Chromium" --> doShift "1"
    , className =? "Evince" --> doShift "3"
    ]

main :: IO ()
main = xmonad
    . ewmh
    . ewmhFullscreen
    -- . setEwmhWorkspaceSort getSortByXineramaRule
    -- . withEasySB (statusBarProp "xmobar ~/.config/xmonad/xmobarrc.icons" (pure myXmobarPP)) defToggleStrutsKey
    . withEasySB (statusBarProp "/home/nikita/.config/polybar/launch_polybar.sh" (pure def)) defToggleStrutsKey
    $ myConfig


myConfig = def
  { modMask = mod4Mask
  , layoutHook = myLayout
  , terminal = "st tmux"
  , borderWidth = 3
  , normalBorderColor  = "#5e5f67"
  , focusedBorderColor = "#d2d9f8"
  , manageHook = myManageHook
  -- , manageHook = placeHook myPlacement <> manageHook def
  , startupHook = autostart
  }

  `additionalKeysP`
    [ ("M-p", spawn "dmenu_run")
    , ("M-q", kill)
    , ("M-S-r", spawn "if type xmonad; then xmonad --recompile && xmonad --restart; else xmessage xmonad not in \\$PATH: \"$PATH\"; fi")
    , ("M-<Tab>", sendMessage NextLayout)
    , ("M-S-q", spawn "systemctl poweroff")
    , ("M-S-e",  io exitSuccess)
    , ("<XF86MonBrightnessUp>", spawn "/home/nikita/.config/xmonad/brightness.sh up")
    , ("<XF86MonBrightnessDown>", spawn "/home/nikita/.config/xmonad/brightness.sh down")
    -- , ("<XF86AudioLowerVolume>", spawn "amixer sset Master 5%-")
    -- , ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 5%+")
    , ("<XF86AudioLowerVolume>", spawn "/home/nikita/.config/xmonad/volume.sh down")
    , ("<XF86AudioRaiseVolume>", spawn "/home/nikita/.config/xmonad/volume.sh up")
    , ("<XF86AudioMute>", spawn "/home/nikita/.config/xmonad/volume.sh mute")
		, ("<Print>", spawn "flameshot gui")
		, ("M-s", spawn "flameshot gui")
		, ("M-<Return>", dwmpromote)
    ]
  `removeKeysP`

    [ "M-<Space>"
    ]
