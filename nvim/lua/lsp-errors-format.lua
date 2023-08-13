vim.diagnostic.config {
    -- signs = true,
    -- float = { source = "always" },
    -- current_line_virt = true,
    virtual_text = false,
    -- severity_sort = true,
}
-- vim.o.updatetime = 500
vim.keymap.set('n', '<Leader>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

require("trouble").setup {
    position = "bottom",
    multiline = true,
    icons = false,
    fold_open = "v", -- icon used for open folds
    fold_closed = ">", -- icon used for closed folds
    indent_lines = false, -- add an indent guide below the fold icons
    width = 10,
    mode = "document_diagnostics",
    use_diagnostic_signs = true,
    signs = {
        -- icons / text used for a diagnostic
        error = "error",
        warning = "warn",
        hint = "hint",
        information = "info"
    },
    action_keys = {
        close = "q",
        cancel = "<esc>",
        hover = "<leader>e"
    },

}
vim.api.nvim_set_keymap('n', '<Leader>xx', ':TroubleToggle document_diagnostics<CR>', { silent = true })
vim.keymap.set("n", "<leader>xw", ':TroubleToggle workspace_diagnostics<CR>', { silent = true })

-- TODO: take care of those:
vim.keymap.set("n", "<leader>xq", function() require("trouble").open("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").open("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").open("lsp_references") end)
