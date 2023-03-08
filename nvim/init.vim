" set mouse=a  " default = nvi
set encoding=utf-8
set number
" set noswapfile
set scrolloff=10
  
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set fileformat=unix
filetype indent on      " load filetype-specific indent files

set smartindent
" set tabstop=2
" set expandtab
" set shiftwidth=2


set ignorecase
set smartcase
set hlsearch
set incsearch

call plug#begin('~/.vim/plugged')
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

" color schemas
Plug 'sainnhe/sonokai'
" Plug 'morhetz/gruvbox'
" Plug 'kaicataldo/material.vim', { 'branch': 'main' }
" Plug 'EdenEast/nightfox.nvim'
" Plug 'jacoborus/tender.vim'
" Plug 'rmehri01/onenord.nvim', { 'branch': 'main' }
" Plug 'Everblush/everblush.nvim', { 'as': 'everblush' }
" Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
" Plug 'sainnhe/gruvbox-material', { 'as': 'sa-gruvbox' }

Plug 'xiyaowong/nvim-transparent'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-commentary'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

Plug 'hashivim/vim-terraform'

call plug#end()

colorscheme sonokai

let g:transparent_enabled = v:false

if (has('termguicolors'))
  set termguicolors
endif

nnoremap ,<space> :nohlsearch<CR>
nnoremap .<space> :TransparentToggle<CR>

lua << EOF
vim.o.completeopt = 'menuone,noselect'

-- luasnip setup
local luasnip = require 'luasnip'
local async = require "plenary.async"

-- Set up nvim-cmp.
local cmp = require'cmp'
cmp.setup {
  completion = {
    autocomplete = false,
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
      }, 
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
  },
  window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
      },
}


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
-- local on_attach = function(client, bufnr)

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}
-- Set LSP config
local nvim_lsp = require('lspconfig')
nvim_lsp.pyright.setup{
    on_attach = on_attach,
    flags = lsp_flags,
}

require'lspconfig'.terraformls.setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require'lspconfig'.tflint.setup{}

EOF

let g:netrw_liststyle = 3
let g:netrw_browse_split = 3

autocmd FileType python set colorcolumn=80
set splitright


lua << EOF
require('telescope').load_extension('fzf')
EOF

autocmd BufWritePre *.tfvars lua vim.lsp.buf.format()
autocmd BufWritePre *.tf lua vim.lsp.buf.format()

""let g:terraform_align = 1
""let g:terraform_fmt_on_save = 0


lua << EOF
vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
EOF

autocmd FileType terraform :iabbr <buffer> trr resource "" "" {<CR><CR>}<UP><UP><esc>0eeh
autocmd FileType terraform :iabbr <buffer> trv variable "" {<CR><CR>}<UP><UP><esc>0eeh

let mapleader = ";"
nnoremap <leader>' viw<esc>a"<esc>bi"<esc>lell

nnoremap ,f <cmd>Telescope find_files<cr>
nnoremap ,g <cmd>Telescope live_grep<cr>

nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>

nnoremap H gT
nnoremap L gt

set clipboard=unnamedplus

" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#keymap#enabled = 0
let g:airline_section_z = "\ue0a1:%l/%L Col:%c"
let g:Powerline_symbols='unicode'

let g:indentLine_enabled = 0
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

