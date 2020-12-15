--
-- xmonad example config file.
--

import XMonad

import Data.Monoid
import qualified Data.Map as M

import System.Exit
import System.IO

import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))

import XMonad.Actions.CopyWindow (copyToAll, kill1, killAllOtherCopies)
import XMonad.Actions.SpawnOn
import XMonad.Actions.WithAll (sinkAll, killAll)

import XMonad.Util.SpawnOnce
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad

import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)

import qualified XMonad.StackSet as W



myFont :: String
myFont = "xft:Mononoki Nerd Font:bold:size=12:antialias=true:hinting=true"

myTerminal :: String
myTerminal = "alacritty"

myBrowser :: String 
myBrowser = "chromium"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth :: Dimension
myBorderWidth   = 1

myModMask :: KeyMask
myModMask       = mod4Mask

-- myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]
myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]

myNormalBorderColor  = "#292d3e"
myFocusedBorderColor = "#bbc5ff"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                ]
  where
    spawnTerm  = myTerminal ++ " --class scratchpad,Alacritty"
    findTerm   = resource =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.5
                 w = 0.4
                 t = 0.55 -h
                 l = 0.45 -w

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myClickableWorkspaces :: [String]
myClickableWorkspaces = clickable . (map xmobarEscape)
               $ [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
              --  $ [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]
  where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..9] l,
                      let n = i ]

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "${HOME}/.local/bin/remaps &"
    spawnOnce "xsetroot -cursor_name left_ptr &"
    spawnOnce "nitrogen --restore &"
    spawnOnce "picom &"
    spawnOnce myTerminal
    spawnOnce "telegram-desktop"
    spawnOnce "code-oss"
    spawnOnce myBrowser
    -- spawnOnce "nm-applet &"
    -- spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x292d3e  --height 22 &"
    setWMName "LG3D"


myLayout = tiled ||| Mirror tiled ||| Full
  where
     tiled   = spacingRaw True (Border i i i i) True (Border i i i i) True $ Tall nmaster delta ratio

     i = 6 -- Spacing size
     nmaster = 1 -- The default number of windows in the master pane
     ratio   = 1/2 -- Default proportion of screen occupied by master pane
     delta   = 3/100 -- Percent of screen to increment by when resizing panes

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
    [ title =? "Mozilla Firefox" --> doShift ( myClickableWorkspaces !! 1 )
    , className =? "Chromium" --> doShift ( myClickableWorkspaces !! 1 )
    , className =? "Code - OSS" --> doShift ( myClickableWorkspaces !! 2 )
    , className =? "TelegramDesktop" --> doShift ( myClickableWorkspaces !! 3 )
    , className =? "MPlayer" --> doFloat
    , resource  =? "Toolkit" --> doFloat -- for Firefox
    , title =? "Picture in picture" --> doFloat -- for Chromium
    , className =? "Gscreenshot" --> doFloat
    , className =? "Virt-manager" --> doFloat
    , className =? "Nitrogen" --> doFloat
    , className =? "Lxappearance" --> doFloat
    , className =? "Blueman-manager" --> doFloat
    , className =? "Nm-connection-editor" --> doFloat
    , className =? "Blueman-services" --> doFloat
    , className =? "qt5ct" --> doFloat
    , className =? "Kvantum Manager" --> doFloat
    , className =? "Ristretto" --> doFloat
    , resource =? "desktop_window" --> doIgnore
    , resource =? "kdesktop" --> doIgnore 
    , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
    ] <+> namedScratchpadManageHook myScratchPads


myKeys = 
    -- Xmonad
        [ ("M-c", spawn "xmonad --recompile; xmonad --restart")
        , ("M-S-q", io exitSuccess)             -- Quits xmonad

    -- Kill windows
        , ("M-q", kill1)                         -- Kill the currently focused client
        , ("M-S-v", killAll)                       -- Kill all windows on current workspace

    -- Floating windows
        -- , ("M-f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile

    -- Launch some programs
        , ("M-<Return>", spawn myTerminal)
        , ("M-p", spawn "dmenu_run -fn 'Mononoki Nerd Font Bold Mono-13'") -- launch dmenu
        , ("M-x", spawn "betterlockscreen -l dimblur") -- lock screen
        , ("M-s", spawn "flameshot gui") -- flameshot
        , ("M-S-s", spawn "gscreenshot") -- gscreenshot
    
    -- Scratchpads
        , ("M-e", namedScratchpadAction myScratchPads "terminal")

    -- Window Copying Bindings
        , ("M-a"            , windows copyToAll ) -- Pin to all workspaces
        , ("M-C-a"          , killAllOtherCopies) -- remove window from all but current
        , ("M-S-a"          , kill1             ) -- remove window from current, kill if only one

    -- Focus    
        , ("M-j", windows W.focusDown) -- Move focus to the next window
        , ("M-k", windows W.focusUp) -- Move focus to the previous window  
        , ("M-m", windows W.focusMaster) -- Move focus to the master window        
        , ("M-S-<Return>", windows W.swapMaster) -- Swap the focused window and the master window        
        , ("M-S-j", windows W.swapDown) -- Swap the focused window with the next window        
        , ("M-S-k", windows W.swapUp) -- Swap the focused window with the previous window    
        , ("M-h", sendMessage Shrink) -- Shrink the master area        
        , ("M-l", sendMessage Expand) -- Expand the master area

    -- Multimedia keys
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 5%- unmute")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 5%+ unmute")

    -- Brightness control
        , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 1")
        , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 1")

    -- Misc
        , ("M-,", sendMessage (IncMasterN 1)) -- Increment the number of windows in the master area
        , ("M-.", sendMessage (IncMasterN (-1))) -- Deincrement the number of windows in the master area
        , ("M-b", sendMessage ToggleStruts) -- Key binding to toggle the gap for the bar.
        , ("M-<Space>", sendMessage NextLayout) -- Rotate through the available layout algorithms
    ]


myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)) -- mod-button1, Set the window to floating mode and move by dragging
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster)) -- mod-button2, Raise the window to the top of the stack
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster)) -- mod-button3, Set the window to floating mode and resize by dragging
    ]


main = do 
    xmproc <- spawnPipe "xmobar ~/.config/xmobar/xmobar1.hs"
    xmonad $ ewmh $ def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myClickableWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = avoidStruts $ smartBorders $ myLayout,
        manageHook         = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks,
        handleEventHook    = docksEventHook,
        startupHook        = myStartupHook,
        logHook = dynamicLogWithPP xmobarPP
          { ppOutput = hPutStrLn xmproc
          , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]" -- Current workspace in xmobar
          , ppVisible = xmobarColor "#98be65" ""                -- Visible but not current workspace
          , ppHidden = xmobarColor "#82AAFF" "" . wrap "*" ""   -- Hidden workspaces in xmobar
          , ppHiddenNoWindows = xmobarColor "#c792ea" ""        -- Hidden workspaces (no windows)
          , ppTitle = xmobarColor "#b3afc2" "" . shorten 60     -- Title of active window in xmobar
          , ppSep =  "<fc=#666666> <fn=2>|</fn> </fc>"          -- Separators in xmobar
          , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
          , ppExtras  = [windowCount]                           -- # of windows current workspace
          , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
          }
    } `additionalKeysP` myKeys