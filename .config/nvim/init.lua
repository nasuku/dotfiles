local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- mixed indent
function MIstatus()
  local space_pat = [[\v^ +]]
  local tab_pat = [[\v^\t+]]
  local space_indent = vim.fn.search(space_pat, 'nwc')
  local tab_indent = vim.fn.search(tab_pat, 'nwc')
  local mixed = (space_indent > 0 and tab_indent > 0)
  local mixed_same_line
  if not mixed then
    mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], 'nwc')
    mixed = mixed_same_line > 0
  end
  if not mixed then return '' end
  if mixed_same_line ~= nil and mixed_same_line > 0 then
     return 'MI:'..mixed_same_line
  end
  local space_indent_cnt = vim.fn.searchcount({pattern=space_pat, max_count=1e3}).total
  local tab_indent_cnt =  vim.fn.searchcount({pattern=tab_pat, max_count=1e3}).total
  if space_indent_cnt > tab_indent_cnt then
    return 'MI:'..tab_indent
  else
    return 'MI:'..space_indent
  end
end

-- trailing whitespace to be shown in lualine
function TWline()
  local space = vim.fn.search([[\s\+$]], 'nwc')
  return space ~= 0 and "TW:"..space or ""
end
----------------
--- plugins ---
----------------
require("lazy").setup({
  { 'ntpeters/vim-better-whitespace' },
  { "mcauley-penney/tidy.nvim" , config = true , },
  {
    'chrisbra/unicode.vim'
  },
  {
   "NLKNguyen/papercolor-theme",
   priority = 1000,
   config = function()
     vim.cmd([[colorscheme PaperColor]])
   end,
  },
  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function ()
      local custom_theme = require'lualine.themes.powerline_dark'
      local colors = {
        black        = '#202020',
        neon         = '#DFFF00',
        white        = '#FFFFFF',
        green        = '#00D700',
        purple       = '#5F005F',
        blue         = '#00DFFF',
        darkblue     = '#00005F',
        navyblue     = '#000080',
        brightgreen  = '#9CFFD3',
        gray         = '#444444',
        darkgray     = '#3c3836',
        lightgray    = '#504945',
        inactivegray = '#7c6f64',
        orange       = '#FFAF00',
        red          = '#5F0000',
        brightorange = '#C08A20',
        brightred    = '#AF0000',
        cyan         = '#00DFFF',
      }
      custom_theme.inactive = {
        a = { bg = colors.gray, fg = colors.white, gui = 'bold' },
        b = { bg = colors.gray, fg = colors.white },
        c = { bg = colors.gray, fg = colors.white },
      }
      require("lualine").setup({
        options = { theme = custom_theme },
        sections = {
          lualine_x = {'vim.fn.getcwd()', 'TWline()', 'MIstatus()'},
          lualine_c = { { 'filename', path =1 } }
        }
      })
    end,
  },

  -- testing framework
  {
    "vim-test/vim-test",
    config = function ()
      vim.g['test#strategy'] = 'neovim'
      vim.g['test#neovim#start_normal'] = '1'
      vim.g['test#neovim#term_position'] = 'vert'
    end,
  },


  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        filters = {
          dotfiles = false,
          git_clean = false,
          no_buffer = false,
        },
      })
    end,
  },

  -- save my last cursor position
  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup({
        lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
        lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
        lastplace_open_folds = true
      })
    end,
  },

  -- commenting out lines
  {
    "numToStr/Comment.nvim",
    config = function()
        require('Comment').setup()
    end
  },

  {
    "bennypowers/splitjoin.nvim",
    keys = {
      { 'gJ', function() require'splitjoin'.join() end, desc = 'Join the object under cursor' },
      { 'gS', function() require'splitjoin'.split() end, desc = 'Split the object under cursor' },
    },
  },

  -- fzf extension for telescope with better speed
  {
    "nvim-telescope/telescope-fzf-native.nvim", run = 'make'
  },

  {'nvim-telescope/telescope-ui-select.nvim' },

  -- fuzzy finder framework
  {
    "nvim-telescope/telescope.nvim",
    tag = '0.1.4',
    dependencies = {
      "nvim-lua/plenary.nvim" ,
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "olimorris/persisted.nvim",
    },
    config = function ()
      require("telescope").setup({
        pickers = {
          buffers = {
            sort_mru = true
          }
        },
        extensions = {
          fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                             -- the default case_mode is "smart_case"
          },
          persisted = {}
        }
      })

      -- To get fzf loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      -- require('telescope').load_extension('fzf')

      -- To get ui-select loaded and working with telescope, you need to call
      -- load_extension, somewhere after setup function:
      require("telescope").load_extension("ui-select")
      require('telescope').load_extension('persisted')
    end,
  },

  -- lsp-config
  {
    "neovim/nvim-lspconfig",
    priority = 905,
    config = function ()
      util = require "lspconfig/util"

      local capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
      capabilities.textDocument.completion.completionItem.snippetSupport = true

    end,
  },

  -- Alternate between files, such as foo.go and foo_test.go
  {
    "rgroli/other.nvim",
    keys = {
      { ":A", "<cmd>Other<cr>", {noremap = true, silent = true}},
      { ":AV", "<cmd>OtherVSplit<cr>", {noremap = true, silent = true}},
      { ":AS", "<cmd>OtherSplit<cr>", {noremap = true, silent = true}},
    },
    config = function ()
      require("other-nvim").setup({
        mappings = {
          "rails", --builtin mapping
          {
            pattern = "(.*).go$",
            target = "%1_test.go",
            context = "test",
          },
          {
            pattern = "(.*)_test.go$",
            target = "%1.go",
            context = "file",
          },
        },
      })
    end,
  },

  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'python', 'java', 'go', 'gomod', 'lua', 'ruby', 'vimdoc', 'vim', 'bash', 'fish' },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<space>", -- maps in normal mode to init the node/scope selection with enter
            node_incremental = "<space>", -- increment to the upper named parent
            node_decremental = "<bs>", -- decrement to the previous node
            scope_incremental = "<tab>", -- increment to the upper scope (as defined in locals.scm)
          },
        },
        autopairs = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ["iB"] = "@block.inner",
              ["aB"] = "@block.outer",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']]'] = '@function.outer',
            },
            goto_next_end = {
              [']['] = '@function.outer',
            },
            goto_previous_start = {
              ['[['] = '@function.outer',
            },
            goto_previous_end = {
              ['[]'] = '@function.outer',
            },
          },
          swap = {
             enable = false,
          },
        },
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {
        check_ts = true,
      }
    end
  },

  -- autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")

      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

      luasnip.config.setup {}

      require('cmp').setup({
        snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm { select = true },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        window = {
          documentation = cmp.config.window.bordered(),
        },
        view = {
          entries = {
            name = "custom",
            selection_order = "near_cursor",
          },
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Insert,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = "luasnip" },
          { name = "buffer", keyword_length = 5 },
          { name = "path" },
        },
      })

      -- require('cmp').setup.cmdline("/", {
       --  sources = cmp.config.sources({
       --   { name = "nvim_lsp_document_symbol" },
       --  }, {
       --   { name = "buffer" },
       --  }),
      -- })

      require('cmp').setup.cmdline(":", {
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },


  -- helper to install various language plugins
  {
    "williamboman/mason.nvim",
    priority = 900,
    config = function()
      require("mason").setup()
    end
  },

  -- create sessions
  {
    "olimorris/persisted.nvim",
    priority = 990,
    config = function()
      require('persisted').setup {
        save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"), -- Resolves to ~/.local/share/nvim/sessions/
        autosave = false
      }
    end
  },

  -- {"corntrace/bufexplorer"},
  {'tpope/vim-fugitive'},
  { 'mfussenegger/nvim-jdtls' },
  { 'cossonleo/dirdiff.nvim'},
  {'vim-scripts/grep.vim',
    config = function()
      vim.cmd([[let Grep_Default_Options = '-IR']])
    end
  },
  {'phaazon/hop.nvim',
    config = function()
      require'hop'.setup()
    end
  },
  {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = { }
  },
})

----------------
--- SETTINGS ---
----------------

-- disable netrw at the very start of our init.lua, because we use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.number = true        -- Show line numbers
vim.opt.showmatch = true     -- Highlight matching parenthesis
vim.opt.splitright = true    -- Split windows right to the current windows
vim.opt.splitbelow = true    -- Split windows below to the current windows
vim.opt.autowrite = true     -- Automatically save before :next, :make etc.
vim.opt.autochdir = false     -- Change CWD when I open a file
vim.opt.mouse = 'a'                -- Enable mouse support
vim.opt.clipboard = 'unnamedplus'  -- Copy/paste to system clipboard
vim.opt.swapfile = false           -- Don't use swapfile
vim.opt.ignorecase = true          -- Search case insensitive...
vim.opt.smartcase = true           -- ... but not it begins with upper case
vim.opt.completeopt = 'menuone,noinsert,noselect'  -- Autocomplete options
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "undo"
vim.opt.expandtab = true  -- expand tabs into spaces
vim.opt.shiftwidth = 2    -- number of spaces to use for each step of indent.
vim.opt.tabstop = 2       -- number of spaces a TAB counts for
vim.opt.autoindent = true -- copy indent from current line when starting a new line
vim.opt.wrap = true
vim.opt.grepprg='rg --vimgrep'
vim.opt.background = 'light'
vim.opt.listchars='tab:→ ,trail:▸,extends:>,nbsp:_'
vim.opt.guicursor='a:blinkon0'
vim.opt.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize"


-- This comes first, because we have mappings that depend on leader
-- With a map leader it's possible to do extra key combinations
-- i.e: <leader>w saves the current filek
vim.g.mapleader = ','

-- Fast saving
vim.keymap.set('n', '<Leader>w', ':write!<CR>')
vim.keymap.set('n', '<Leader>q', ':bd!<CR>', { silent = true })

-- Remove search highlight
vim.keymap.set('n', '<Leader><space>', ':nohlsearch<CR>')

-- Search mappings: These will make it so that going to the next one in a
-- search will center on the line it's found in.
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Don't jump forward if I higlight and search for a word
vim.keymap.set('n', '*', '*N')

-- Better split switching
vim.keymap.set('', '<C-j>', '<C-W>j')
vim.keymap.set('', '<C-k>', '<C-W>k')
vim.keymap.set('', '<C-h>', '<C-W>h')
vim.keymap.set('', '<C-l>', '<C-W>l')

-- Visual linewise up and down by default (and use gj gk to go quicker)
vim.keymap.set('n', '<Up>', 'gk')
vim.keymap.set('n', '<Down>', 'gj')

-- Yanking a line should act like D and C
vim.keymap.set('n', 'Y', 'y$')

-- Terminal
-- Clost terminal window, even if we are in insert mode
vim.keymap.set('t', '<leader>q', '<C-\\><C-n>:q<cr>')

-- switch to normal mode with esc
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')

-- Open terminal in vertical and horizontal split
vim.keymap.set('n', '<leader>tv', '<cmd>vnew term://zsh<CR>', { noremap = true })
vim.keymap.set('n', '<leader>ts', '<cmd>split term://zsh<CR>', { noremap = true })

-- Open terminal in vertical and horizontal split, inside the terminal
vim.keymap.set('t', '<leader>tv', '<c-w><cmd>vnew term://zsh<CR>', { noremap = true })
vim.keymap.set('t', '<leader>ts', '<c-w><cmd>split term://zsh<CR>', { noremap = true })

-- mappings to move out from terminal to other views
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l')

-- automatically switch to insert mode when entering a Term buffer
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
    group = vim.api.nvim_create_augroup("openTermInsert", {}),
    callback = function(args)
        -- we don't use vim.startswith() and look for test:// because of vim-test
        -- vim-test starts tests in a terminal, which we want to keep in normal mode
        if vim.endswith(vim.api.nvim_buf_get_name(args.buf), "zsh") then
            vim.cmd("startinsert")
        end
    end,
})

-- don't show number
vim.api.nvim_create_autocmd("TermOpen", {
    command = [[setlocal nonumber norelativenumber]]
})

-- File-tree mappings
vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', { noremap = true })

-- Test
--
-- File-tree mappings
vim.keymap.set('n', '<leader>tt', ':TestNearest -v<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tf', ':TestFile -v<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tl', ':TestLast -v<CR>', { noremap = true, silent = true })

-- Open help window in a vertical split to the right.
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = vim.api.nvim_create_augroup("help_window_right", {}),
    pattern = { "*.txt" },
    callback = function()
        if vim.o.filetype == 'help' then vim.cmd.wincmd("L") end
    end
})

-- telescope
local builtin = require('telescope.builtin')

-- only modified files in git repo.
vim.keymap.set('n', '<C-p>', function() builtin.git_files({git_command={"git","ls-files", "--exclude-standard", "--others", "--modified"} }) end)
-- files in git repo.
-- vim.keymap.set('n', '<C-p>', builtin.git_files, {})

vim.keymap.set('n', '<C-b>', builtin.find_files, {})
vim.keymap.set('n', '<C-g>', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>td', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>f', builtin.grep_string, {})
vim.keymap.set('n', '<leader>gg', builtin.live_grep, {})

-- diagnostics
vim.keymap.set("n", "<leader>o", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>l", vim.diagnostic.setloclist)

-- insert date
vim.keymap.set("n","<leader>d", 'i<C-R>=strftime("%Y-%m-%d")<CR> ')
-- vim.keymap.set("n","<leader>d", 'i<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>')
-- imap <F3> <C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>

-- in case u want to disable diagnostics
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

-- Go uses gofmt, which uses tabs for indentation and spaces for aligment.
-- Hence override our indentation rules.
vim.api.nvim_create_autocmd('Filetype', {
  group = vim.api.nvim_create_augroup('setIndent', { clear = true }),
  pattern = { 'go' },
  command = 'setlocal noexpandtab tabstop=4 shiftwidth=4'
})

-- Run gofmt/gofmpt, import packages automatically on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('setGoFormatting', { clear = true }),
  pattern = '*.go',
  callback = function()
    vim.lsp.buf.format()
    vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' } }, apply = true }
    vim.lsp.buf.code_action { context = { only = { 'source.fixAll' } }, apply = true }
  end
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }

    vim.keymap.set('n', 'gd', "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set('n', '<leader>v', "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set('n', '<leader>s', "<cmd>belowright split | lua vim.lsp.buf.definition()<CR>", opts)

    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>cl', vim.lsp.codelens.run, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, opts)
  end,
})

-- didnt like default bg color of highlight float
vim.cmd[[
hi DiagnosticFloatingError guibg=#ffd787
hi DiagnosticFloatingWarn guibg=#ffd787
hi DiagnosticFloatingHint guibg=#ffd787
hi DiagnosticFloatingInfo guibg=#ffd787
]]

vim.keymap.set('n', ';', ':Telescope buffers<CR>')
vim.keymap.set('n', ',a', ':e <c-r>=expand("%:p:r")<cr>')
vim.keymap.set('n', ',e', ':b#<cr>')
vim.keymap.set('',',cd', ':cd %:p:h<cr>')
vim.keymap.set("", "[q", ':cprevious<cr>')
vim.keymap.set("", "]q", ':cnext<cr>')
vim.keymap.set('','f',':HopChar2<cr>',{remap=true})
vim.lsp.enable('gopls')
vim.lsp.enable('pylsp')
vim.lsp.enable('bashls')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('clangd')
