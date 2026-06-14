return {
  {
    "okuuva/auto-save.nvim",
    version = "^1",
    -- Lazy-load on the events that can trigger a save.
    event = { "InsertLeave", "TextChanged" },
    cmd = "ASToggle", -- :ASToggle to turn autosave on/off
    opts = {
      -- Wait 300ms after the last change before writing (debounced).
      debounce_delay = 300,
    },
  },
}
