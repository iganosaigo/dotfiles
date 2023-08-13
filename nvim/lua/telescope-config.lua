-- local actions = require("telescope.actions")
-- local trouble = require("trouble.providers.telescope")

require('telescope').load_extension('fzf')
require('telescope').setup {
  defaults = {
    ignore_case = true,
    smart_case = true,
    -- mappings = {
    --     i = { ["<c-i>"] = trouble.open_with_trouble },
    --     n = { ["<c-i>"] = trouble.open_with_trouble },
    -- },
  }
}
