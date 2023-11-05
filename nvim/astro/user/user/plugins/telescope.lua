return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make" },
  },
  cmd = "Telescope",
  opts = function()
    local actions = require "telescope.actions"
    local get_icon = require("astronvim.utils").get_icon
    return {
      defaults = {
        -- my settings
        -- path_display = {
        --   shorten = {
        --     len = 12,
        --     exclude = {1, -1}
        --   },
        --   absolute = 1,
        -- },
        file_ignore_patterns = {
          "%.jpg",
          "%.gif",
          "%.png",
          "%.tga",
          "%.tgz",
          "%.gz",
          "%.zip",
        },
        ignore_case = true,
        smart_case = true,
        -- default settings
        git_worktrees = vim.g.git_worktrees,
        prompt_prefix = get_icon("Selected", 1),
        selection_caret = get_icon("Selected", 1),
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = { prompt_position = "top", preview_width = 0.55 },
          vertical = { mirror = false },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        mappings = {
          i = {
            ["<C-j>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            -- ["<esc>"] = actions.close
          },
          n = { q = actions.close },
        },
      },
    }
  end,
  config = require "plugins.configs.telescope",
}
