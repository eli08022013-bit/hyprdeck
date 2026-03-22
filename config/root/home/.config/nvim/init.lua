-- BASICS
vim.g.mapleader = ' '
local opt = vim.opt
local settings = {
  number = true,
  relativenumber = true,
  mouse = 'a',
  undofile = true,
  termguicolors = true,
  updatetime = 250,
  timeoutlen = 300,
  cursorline = true,
}
for k, v in pairs(settings) do opt[k] = v end

-- BOOTSTRAP
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- PLUGINS
require("lazy").setup({
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    config = function() 
      vim.g.everforest_background = 'medium'
      vim.g.everforest_better_performance = 1
      vim.cmd.colorscheme "everforest"
    end
  },
  {
    "rebelot/heirline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local conditions = require("heirline.conditions")
      local colors = {
        bg = "#2d353b",
        fg = "#d3c6aa",
        green = "#a7c080",
        blue = "#7fbbb3",
        orange = "#e69875",
        grey = "#859289",
      }
      local ViMode = {
        init = function(self) self.mode = vim.fn.mode(1) end,
        static = {
          mode_colors = {
            n = colors.green, i = colors.blue, v = colors.orange,
            V = colors.orange, ["\22"] = colors.orange, c = colors.orange,
          }
        },
        provider = function(self) return " 󰊄 %2(" .. self.mode .. "%) " end,
        hl = function(self)
          return { fg = colors.bg, bg = self.mode_colors[self.mode:sub(1, 1)], bold = true }
        end,
      }
      local FileName = {
        provider = function() return " %f " end,
        hl = { fg = colors.fg, bg = "#3d484d" },
      }
      local LSPActive = {
        condition = conditions.lsp_attached,
        provider = function()
          local names = {}
          for _, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
          end
          return "  [" .. table.concat(names, " ") .. "] "
        end,
        hl = { fg = colors.green, bold = true },
      }
      require("heirline").setup({
        statusline = { ViMode, FileName, { provider = "%=" }, LSPActive, { provider = " %P %l:%c ", hl = { fg = colors.grey } } }
      })
    end
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { '<leader>sf', function() require('telescope.builtin').find_files() end, desc = 'Search Files' },
      { '<leader><leader>', function() require('telescope.builtin').buffers() end, desc = 'Find Buffers' },
    }
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local servers = { "html", "cssls", "ts_ls", "bashls", "clangd", "rust_analyzer", "lua_ls", "qmlls" }
      for _, server in ipairs(servers) do
        vim.lsp.enable(server)
        vim.lsp.config(server, { 
          capabilities = capabilities,
          settings = server == "lua_ls" and { Lua = { diagnostics = { globals = { "vim" } } } } or nil
        })
      end
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        end,
      })
    end,
  },
  {
    'saghen/blink.cmp',
    version = '*',
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
    }
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Use a safe pcall to load the config, which is more robust
      local status, configs = pcall(require, "nvim-treesitter.configs")
      if not status then 
        -- If it fails, we fall back to the basic setup
        return 
      end
      
      configs.setup({
        ensure_installed = { "bash", "c", "cpp", "html", "javascript", "typescript", "rust", "lua", "vim", "vimdoc", "qmljs" },
        highlight = { enable = true },
      })
    end,
  },
})

-- COMMANDS
vim.api.nvim_create_user_command("UwU", function() print("uwu") end, { desc = "uwu" })
vim.api.nvim_create_user_command("MC", function(f)
    local track = f.args
    if track == "" then
        print("Usage: :MC <search/track>")
        return
    end

vim.fn.system("mc play " .. track)
    print('Playing song')
end, { nargs = "*" })
