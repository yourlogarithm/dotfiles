-- Hammerspoon (macOS only): global hotkeys.

-- Start at login so the hotkeys are always available.
hs.autoLaunch(true)

-- Enable the `hs` CLI (hs -c 'hs.reload()').
require("hs.ipc")

-- cmd+return: open a new kitty window every time. If kitty isn't running,
-- launching it opens the first window; otherwise click its "New OS Window"
-- menu item (a synthetic cmd+n gets lost while cmd is still held down).
-- Global, so it overrides cmd+return in every other app.
hs.hotkey.bind({ "cmd" }, "return", function()
  local app = hs.application.get("net.kovidgoyal.kitty")
  if not app then
    hs.application.launchOrFocus("kitty")
    return
  end
  app:activate()
  app:selectMenuItem("New OS Window")
end)
