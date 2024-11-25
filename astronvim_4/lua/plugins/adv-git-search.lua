return {
  "aaronhallaert/advanced-git-search.nvim",
  cmd = { "AdvancedGitSearch" },
  config = function()
    -- optional: setup telescope before loading the extension
    require("telescope").setup {
      -- move this to the place where you call the telescope setup function
      extensions = {
        advanced_git_search = {
          show_builtin_git_pickers = true,
          keymaps = {
            -- following keymaps can be overridden
            toggle_date_author = "<C-a>",
            open_commit_in_browser = "<C-o>",
          },
          -- telescope_theme = {
          --   show_custom_functions = {
          --     layout_config = { width = 0.4, height = 0.4 },
          --   },
          -- },
        },
      },
    }

    require("telescope").load_extension "advanced_git_search"
  end,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    -- to show diff splits and open commits in browser
    "tpope/vim-fugitive",
    -- to open commits in browser with fugitive
    "tpope/vim-rhubarb",
    -- optional: to replace the diff from fugitive with diffview.nvim
    -- (fugitive is still needed to open in browser)
    -- "sindrets/diffview.nvim",
  },
}
