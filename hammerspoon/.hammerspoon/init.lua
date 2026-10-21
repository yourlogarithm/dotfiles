-- Hammerspoon (macOS only): global hotkeys.

-- Start at login so the hotkeys are always available.
hs.autoLaunch(true)

-- cmd+return: open a new kitty window every time. If kitty isn't running,
-- launching it opens the first window; otherwise send it cmd+n (kitty's
-- default new_os_window). Global, so it overrides cmd+return in every other app.
hs.hotkey.bind({ "cmd" }, "return", function()
  local app = hs.application.get("net.kovidgoyal.kitty")
  if not app then
    hs.application.launchOrFocus("kitty")
    return
  end
  app:activate()
  hs.eventtap.keyStroke({ "cmd" }, "n", 0, app)
end)
