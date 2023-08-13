" set mouse=a  " default = nvi
" set noswapfile

set nocompatible
set encoding=utf-8
set number
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
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'windwp/nvim-autopairs'

" color schemas
Plug 'sainnhe/sonokai'
Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material', { 'as': 'sa-gruvbox' }

Plug 'xiyaowong/nvim-transparent'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'sheerun/vim-polyglot'
Plug 'pearofducks/ansible-vim' , { 'do': './UltiSnips/generate.sh' }
Plug 'tpope/vim-commentary'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'airblade/vim-gitgutter'
Plug 'Yggdroot/indentLine'
Plug 'hashivim/vim-terraform'
Plug 'folke/trouble.nvim'
Plug 'stsewd/isort.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'nvim-tree/nvim-web-devicons'

call plug#end()

let g:black_value = 80
nnoremap <F2> :execute "!black -l " . g:black_value . " %"<CR><CR>

let mapleader = ";"

lua << EOF
enable_pylsp = false
enable_pyright = true
enable_terraform = true
enable_ansible = true
enable_bash = true

vim.o.completeopt = 'menuone,noselect'

local async = require "plenary.async" 
require('nvim-cmp-config')
-- require('lspservers-config')
require('lspconfig-config')
require('telescope-config')
require("nvim-autopairs").setup {}

require'lspconfig'.terraformls.setup{
    on_attach = on_attach,
    flags = lsp_flags,
}
require'lspconfig'.tflint.setup{}
require('telescope').load_extension('fzf')
require('telescope').setup {
    defaults = {
        ignore_case = true,
        smart_case = true,
    }
}
require('lsp-errors-format')

EOF

colorscheme sonokai

nnoremap H gT
nnoremap L gt

set clipboard=unnamedplus

if (has('termguicolors'))
    set termguicolors
endif

nnoremap ,<space> :nohlsearch<CR>
nnoremap .<space> :TransparentToggle<CR>

nnoremap <silent> gv :vsplit<CR><C-]>
nnoremap <silent> gs :split<CR><C-]>

" Default transparent mode "
let g:transparent_enabled = v:false

" Telescope Mappings "
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>g <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fc <cmd>Telescope colorscheme<cr>
nnoremap <leader>f/ <cmd>Telescope current_buffer_fuzzy_find<cr>

" Terraform "
autocmd BufWritePre *.tfvars lua vim.lsp.buf.format()
autocmd BufWritePre *.tf lua vim.lsp.buf.format()
""let g:terraform_align = 1
""let g:terraform_fmt_on_save = 0
nnoremap <leader>' viw<esc>a"<esc>bi"<esc>lell

au BufRead,BufNewFile *\v*/molecule/*.(yml|yaml)$ set filetype=yaml.ansible
let g:ansible_unindent_after_newline = 1

" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#keymap#enabled = 0
let g:airline_section_z = "\ue0a1:%l/%L Col:%c"
let g:Powerline_symbols='unicode'

let g:indentLine_enabled = 1
let g:indentLine_char_list = ['|', '¦', '┆', '┊']


let g:netrw_liststyle = 3
let g:netrw_browse_split = 3

autocmd FileType python set colorcolumn=80
set splitright



