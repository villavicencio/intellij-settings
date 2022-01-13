-- This is an example init file , its supposed to be placed in /lua/custom dir
-- lua/custom/init.lua

-- This is where your custom modules and plugins go.
-- Please check NvChad docs if you're totally new to nvchad + dont know lua!!

local customPlugins = require "core.customPlugins"
local map = require("core.utils").map

-- hooks.add("setup_mappings", function(map)
map("n", "<leader>fg", ":Telescope live_grep <CR>", opt)
map("n", "<leader>q", ":q <CR>", opt)
map("n", "<leader>f", ":TZAtaraxis <CR>", opt)
-- end)

-- NOTE : opt is a variable  there (most likely a table if you want multiple options),
-- you can remove it if you dont have any custom options

customPlugins.add(function(use)
  use {
    "Pocco81/TrueZen.nvim",
    cmd = {
      "TZAtaraxis",
      "TZMinimalist",
      "TZFocus",
    },
    config = function()
      -- check https://github.com/Pocco81/TrueZen.nvim#setup-configuration (init.lua version)
    end
  }  
  
  use {
    "karb94/neoscroll.nvim",
    opt = true,
    config = function()
      require("neoscroll").setup()
    end,
    
    -- lazy loading
    setup = function()
      require("core.utils").packer_lazy_load "neoscroll.nvim"
    end,
  }

  use { 
    "nathom/filetype.nvim"
  }

  use {
    "luukvbaal/stabilize.nvim",
    config = function() require("stabilize").setup() end
  }

  use {
    "SidOfc/mkdx",

    setup = function()
      -- Disable tab mapping which was preventing tabbing buffers
      vim.g["mkdx#settings"] = {
        tab = {enable = 0},
      }
    end,
  }

  use {
    "vim-pandoc/vim-pandoc-syntax"
  }

  use {
    "reedes/vim-pencil"
  }

  use({
    "jose-elias-alvarez/null-ls.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("null-ls").setup({
        sources = {
          require("null-ls").builtins.diagnostics.vale.with({
            filetypes = { "markdown", "tex", "markdown.pandoc" },
            extra_args = {
              "--config",
              vim.fn.expand("$DOTFILES/vale/vale.ini"),
            },
          }),
        },
        on_attach = function(client)
          if client.resolved_capabilities.document_formatting then
            vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
            vim.cmd[[ au FileType markdown.pandoc lua require("cmp").setup.buffer({completion={autocomplete=false}}) ]]
          end
        end,
      })
    end,
    requires = { "nvim-lua/plenary.nvim" },
  })

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }
end)

-- Stop sourcing filetype.vim
vim.g.did_load_filetypes = 1

-- Set md filetype to pandoc
vim.cmd[[ au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc ]]

-- Set soft wrap when editing markdown
vim.cmd[[ autocmd FileType markdown,md,markdown.pandoc call pencil#init({'wrap': 'soft'}) ]]

-- NOTE: we heavily suggest using Packer's lazy loading (with the 'event' field)
-- see: https://github.com/wbthomason/packer.nvim
-- https://nvchad.github.io/config/walkthrough
