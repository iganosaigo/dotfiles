local lspconfig = require('lspconfig')
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lsp_flags = { debounce_text_changes = 150 }

-- Mappings for hover and signature_help
local function set_hover_mapping(mode, bufopts)
    vim.keymap.set(mode, '<C-k>', vim.lsp.buf.hover, bufopts)
end
local function set_signature_help_mapping(mode, bufopts)
    vim.keymap.set(mode, '<C-s>', vim.lsp.buf.signature_help, bufopts)
end

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.hover, bufopts)
    set_hover_mapping('i', bufopts)
    set_hover_mapping('n', bufopts)
    set_signature_help_mapping('i', bufopts)
    set_signature_help_mapping('n', bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
end

-- TODO: make this with nested structures and loop
-- local servers = {'pylsp', 'terraformls'}
-- if next(servers) ~= nill then
--   for _, lsp in ipairs(servers) do
--     lspconfig[lsp].setup {
--       on_attach = on_attach,
--       capabilities = capabilities,
--       lsp_flags = lsp_flags
--     } 
--   end
-- end

local common_lsp_params = {
    on_attach = on_attach,
    capabilities = capabilities,
    lsp_flags = lsp_flags,
}

if enable_pylsp then
    lspconfig.pylsp.setup(common_lsp_params)
end
  
if enable_pyright then
    lspconfig.pyright.setup(common_lsp_params)
end

if enable_terraform then
    lspconfig.terraformls.setup(common_lsp_params)
	lspconfig.tflint.setup{}
    vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
    vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
    vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
    vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
    vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
end

if enable_ansible then
    local custom_params = vim.tbl_extend('force', common_lsp_params, {
    cmd = { 'ansible-language-server', '--stdio' },
    settings = {
        ansible = {
            python = {
                interpreterPath = 'python',
            },
            ansible = {
                path = 'ansible',
            },
            executionEnvironment = {
                enabled = false,
            },
            validation = {
                enabled = true,
                lint = {
                    enabled = true,
                    path = 'ansible-lint',
                }
            }
        }
    },
        filetypes = { 'yaml.ansible' },
        -- root_dir = util.root_pattern('ansible.cfg', '.ansible-lint'),
        -- single_file_support = true,
    })
    lspconfig.ansiblels.setup(custom_params)
end

