-- Hammerspoon (macOS only): global hotkeys.

-- Start at login so the hotkeys are always available.
hs.autoLaunch(true)

-- cmd+return: launch kitty, or bring it to the front (opening a window if it
-- has none). Global, so it overrides cmd+return in every other app.
hs.hotkey.bind({ "cmd" }, "return", function()
  hs.application.launchOrFocus("kitty")
end)
