return {
  {
    -- Open files from an in-nvim terminal in the HOST nvim instead of nesting
    -- a new nvim. Also makes git's $EDITOR open in the host and block.
    "willothy/flatten.nvim",
    config = true,
    lazy = false,
    priority = 1001, -- must load before other plugins to intercept early
  },
}
