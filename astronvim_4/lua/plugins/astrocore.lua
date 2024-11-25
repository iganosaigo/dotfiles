-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "auto", -- sets vim.opt.signcolumn to auto
        wrap = true, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      n = {
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        -- ["<Leader>H"] = { ":tabprevious<cr>", desc = "Tab Previous" },
        -- ["<Leader>L"] = { ":tabnext<cr>", desc = "Tab Next" },

        -- popd and pushd
        ["<Leader>pd"] = { ":pushd %:p:h<cr>", desc = "Pushd" },

        -- Buffers
        ["<Leader>b"] = { desc = "Buffers" },
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- Quick save
        ["<C-s>"] = { ":w!<cr>", desc = "Save File" },

        -- toggleterm
        ["<Leader>tr"] = {
          function() require("astrocore").toggle_term_cmd "ranger" end,
          desc = "ToggleTerm ranger",
        },
        ["<Leader>tR"] = {
          function()
            require("astrocore").toggle_term_cmd {
              cmd = "ranger",
              direction = "horizontal",
            }
          end,
          desc = "ToggleTerm horizontal ranger",
        },

        -- Telescope mappings
        -- ["<Leader>gC"] = {
        --   function()
        --     require("telescope.builtin").git_bcommits {
        --       use_file_path = true,
        --       git_command = { "git", "log", "--pretty=oneline", "--abbrev-commit" },
        --     }
        --   end,
        --   desc = "Git commits (current file)",
        -- },
        ["<Leader>fw"] = false,
        ["<Leader>fW"] = false,
        ["<Leader>fg"] = {
          function() require("telescope.builtin").live_grep() end,
          desc = "Grep",
        },
        ["<Leader>fG"] = {
          function()
            require("telescope.builtin").live_grep {
              additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
            }
          end,
          desc = "Grep no hiiden and ignore",
        },
        ["<Leader>fGa"] = {
          function() require("telescope").extensions.live_grep_args.live_grep_args() end,
          desc = "Find words with args",
        },
        ["<Leader>fc"] = false,
        ["<Leader>fs"] = {
          function() require("telescope.builtin").grep_string() end,
          desc = "Find word under cursor",
        },
        ["<Leader>fm"] = {
          function() require("telescope.builtin").man_pages { sections = { "ALL" } } end,
          desc = "Find MAN",
        },
        ["<Leader>fH"] = {
          function()
            require("telescope.builtin").find_files {
              hidden = true,
              no_ignore = true,
            }
          end,
          desc = "Find all files",
        },
        ["<Leader>ft"] = {
          function()
            require("telescope.builtin").colorscheme {
              enable_preview = true,
              colors = {
                "sonokai",
                "gruvbox",
                "astrodark",
              },
            }
          end,
          desc = "Find themes",
        },
        ["<Leader>fR"] = {
          function() require("telescope").extensions.advanced_git_search() end,
          desc = "Advanced Git",
        },
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },
    },
  },
}
