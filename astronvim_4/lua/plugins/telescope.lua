return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", enabled = vim.fn.executable "make" == 1, build = "make" },
  },
  cmd = "Telescope",
  opts = function()
    local actions = require "telescope.actions"
    local get_icon = require("astroui").get_icon
    return {
      defaults = {
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
        wrap_results = false, -- in search window
        ignore_case = true,
        smart_case = true,
        git_worktrees = vim.g.git_worktrees,
        prompt_prefix = get_icon("Selected", 1),
        selection_caret = get_icon("Selected", 1),
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        color_devicons = true,
        -- layout_strategy = 'horizontal',
        layout_strategy = "vertical",
        layout_config = {
          -- horizontal = { prompt_position = "top", preview_width = 0.55 },
          preview_cutoff = 25,
          vertical = {
            height = 0.9,
            prompt_position = "top",
            preview_height = 0.6,
            mirror = true,
          },
          width = 0.9,
          -- height = 0.5,
        },
        mappings = {
          i = {
            ["<C-s>"] = actions.cycle_previewers_next,
            ["<C-a>"] = actions.cycle_previewers_prev,
            ["<C-j>"] = actions.cycle_history_next,
            ["<C-k>"] = actions.cycle_history_prev,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            -- ["<esc>"] = actions.close
          },
          n = {
            q = actions.close,
          },
        },
      },
    }
  end,
}
