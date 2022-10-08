" GENERAL SETTINGS {{{

set expandtab " indent with spaces
set tabstop=4 " indent with 4 spaces
set shiftwidth=4 " shift with 4 spaces
set number " show line numbers
set cursorline " highlight cursor line
set autoindent " auto indent as per line
set termguicolors " enable true-color
syntax enable
filetype plugin indent on
set clipboard=unnamedplus " set clipboard as the one used in the system
set list listchars=tab:»\ ,eol:↴,nbsp:␣,trail:⋅,extends:›,precedes:‹
set mouse=a " enable use of mouse
set guicursor=

" shortcut to open CHADTree ↓
nnoremap <F5> :CHADopen<CR>

command Trim %s/\s\+$// " command to trim trailing whitespace in files

" prevent nvim's window from incorrectly resizing
autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"

" }}}

" VIMSCRIPT {{{

" enable marker folding
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" run cratestoggle when opening cargo.toml files
if has('nvim')
  autocmd BufRead Cargo.toml call crates#toggle()
endif
" }}}

" PLUGINS {{{

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" support for language server/autocompletion
Plug 'neovim/nvim-lspconfig'

" code autocompletion
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

" syntax checking
Plug 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" markdown previewer with glow
Plug 'ellisonleao/glow.nvim'

" statusline
Plug 'nvim-lualine/lualine.nvim'

" melange (orange-based) color-scheme
Plug 'savq/melange'

" treesitter highlighter and stuff
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" ident all lines
Plug 'lukas-reineke/indent-blankline.nvim'

" file-tree
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}

" rust integration
Plug 'rust-lang/rust.vim'

" markdown syntax support
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

" get crates from crates.io when
" editing proper cargo.toml files
Plug 'mhinz/vim-crates'

" have tabs for the files being edited
Plug 'kyazdani42/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim'

call plug#end()

" }}}

" REQUESTING LUA MODULES {{{

lua << EOF
    require'lspconfig'.clangd.setup{}
    require'lspconfig'.bashls.setup{}
    require'lspconfig'.gdscript.setup{}
    require'lspconfig'.pyright.setup{}
    require'lspconfig'.rust_analyzer.setup{}
    require'lspconfig'.html.setup{
        cmd = { "vscode-html-languageserver", "--stdio" }
    }
    require'lspconfig'.vimls.setup{}
    require'lualine'.setup {
        options = { theme = 'gruvbox',
            section_separators = { left = '', right = ''},
            component_separators = { left = '', right = ''},
            disabled_filetypes = {'CHADTree', 'vim-plug'}
        }
    }

    require'nvim-treesitter.configs'.setup {
        highlight = {
            enable = true
        },
        indent = {
            enable = true
        }
    }

    require'indent_blankline'.setup {
        use_treesitter = true,
        filetype_exclude = {'text', 'help', 'CHADTree', 'vim-plug'},
        space_char_blankline = ' ',
        show_end_of_line = true,
        show_current_context = true,
        show_current_context_start = true,
        buftype_exclude = {'terminal'}
    }

    require'bufferline'.setup{
        options = {
            separator_style = "padded_slant",
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
              local icon = level:match("error") and " " or " "
              return " " .. icon .. count
            end,
            custom_filter = function(buf_number)
              -- filter out filetypes you don't want to see
              if vim.bo[buf_number].filetype ~= "qf" then
                return true
              end
            end
        }
    }
EOF

" }}}

colo melange " set the color-scheme

" run commands after startup
autocmd VimEnter * COQnow -s
