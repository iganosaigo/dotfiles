-- local actions = require("telescope.actions")
-- local trouble = require("trouble.providers.telescope")

require('telescope').setup {
    defaults = {
        path_display = {
            shorten = {
                len = 12,
                exclude = {1, -1},
            },
            absolute = 1,
        },
        ignore_case = true,
        smart_case = true,
        -- mappings = {
        --     i = {
        --         ["<esc>"] = require('telescope.actions').close,
        --     },
        --     n = {  },
        -- },
    },
    extensions ={
        fzf = {
            fuzzy = true,
        }
    }
}
require('telescope').load_extension('fzf')

local tb = require('telescope.builtin')
local opts = { noremap = true, silent = true }

function live_grep()
    tb.live_grep({max_results = -1, additional_args = {"-j1"}})
end

function man_pages()
    tb.man_pages({sections = {"ALL"}})
end

function grep_string()
    tb.grep_string(
        {
            -- word_match = "-w",
            use_regex = true,
            file_encoding = 'utf-8'
        }
    )
end


vim.api.nvim_set_keymap('n', '<leader>fm', '<cmd>lua man_pages()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>lua live_grep()<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fs', '<cmd>lua grep_string()<CR>', opts)
vim.keymap.set('n', '<leader>fg', tb.live_grep, {})
vim.keymap.set('n', '<leader>g', tb.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>fb', tb.buffers, {})
vim.keymap.set('n', '<leader>fs', tb.grep_string, {})
vim.keymap.set('n', '<leader>ff', tb.find_files, {})
vim.keymap.set('n', '<leader>ft', tb.help_tags, {})
vim.keymap.set('n', '<leader>fc', tb.colorscheme, {})
vim.keymap.set('n', '<leader>fh', tb.command_history, {})
vim.keymap.set('n', '<leader>rr', tb.lsp_references, {})
vim.keymap.set('n', '<leader>ri', tb.lsp_incoming_calls, {})
vim.keymap.set('n', '<leader>ro', tb.lsp_outgoing_calls, {})
vim.keymap.set('n', '<leader>rd', tb.lsp_definitions, {})
vim.keymap.set('n', '<leader>rt', tb.lsp_type_definitions, {})
