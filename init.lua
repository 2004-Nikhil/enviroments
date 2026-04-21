-- ============================================================
--  init.lua  –  Neovim config on Windows
--  Package manager: Lazy.nvim
--  Last updated: 2025
-- ============================================================


-- winget install BurntSushi.ripgrep.MSVC
-- ── Leader key (must be set before Lazy) ────────────────────
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- ── Core options ────────────────────────────────────────────
local opt = vim.opt

opt.number         = true          -- line numbers
opt.relativenumber = true          -- relative line numbers
opt.tabstop        = 2             -- 2-space tabs (JS/TS standard)
opt.shiftwidth     = 2
opt.expandtab      = true          -- spaces instead of tabs
opt.smartindent    = true
opt.wrap           = false         -- no line wrap
opt.swapfile       = false
opt.backup         = false
opt.undofile       = true          -- persistent undo
opt.hlsearch       = false
opt.incsearch      = true
opt.termguicolors  = true
opt.scrolloff      = 8
opt.signcolumn     = "yes"
opt.updatetime     = 50
opt.colorcolumn    = "100"
opt.splitright     = true
opt.splitbelow     = true
opt.cursorline     = true
opt.ignorecase     = true
opt.smartcase      = true
opt.clipboard      = "unnamedplus" -- share clipboard with Windows
opt.encoding       = "utf-8"
opt.fileencoding   = "utf-8"
opt.mouse          = "a"

-- Windows: use Git Bash as the default shell
-- Adjust path if Git is installed elsewhere (check with: where git)
opt.shell        = "C:/Program Files/Git/bin/bash.exe"
opt.shellcmdflag = "-s"
opt.shellredir   = "2>&1 | tee"
opt.shellpipe    = "2>&1 | tee"
opt.shellquote   = ""
opt.shellxquote  = ""
opt.shellslash   = true   -- use forward slashes in paths (required for bash on Windows)

-- ── Bootstrap Lazy.nvim ─────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ──────────────────────────────────────────────────
require("lazy").setup({

  -- ── Colorscheme ─────────────────────────────────────────
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config   = function()
      require("tokyonight").setup({
        style           = "night",   -- "night" | "storm" | "day" | "moon"
        transparent     = false,
        terminal_colors = true,
        styles = {
          comments  = { italic = true },
          keywords  = { italic = true },
          functions = {},
          variables = {},
          sidebars  = "dark",        -- "dark" | "transparent" | "normal"
          floats    = "dark",
        },
        sidebars = { "qf", "help", "neo-tree", "toggleterm" },
        on_highlights = function(hl, c)
          -- make the current line number stand out a bit more
          hl.LineNrAbove = { fg = c.fg_gutter }
          hl.LineNrBelow = { fg = c.fg_gutter }
        end,
      })
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- ── Status line ─────────────────────────────────────────
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options  = { theme = "tokyonight" },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- ── Buffer tabs ─────────────────────────────────────────
  {
    "akinsho/bufferline.nvim",
    version      = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts         = { options = { diagnostics = "nvim_lsp" } },
  },

  -- ── File explorer ────────────────────────────────────────
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch       = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      -- Remove legacy netrw commands so neo-tree can hijack directory opens
      vim.g.neo_tree_remove_legacy_commands = 1

      require("neo-tree").setup({
        close_if_last_window    = true,
        popup_border_style      = "rounded",
        enable_git_status       = true,
        enable_diagnostics      = true,
        sort_case_insensitive   = true,
        default_component_configs = {
          indent = {
            indent_size            = 2,
            padding                = 1,
            with_markers           = true,
            indent_marker          = "│",
            last_indent_marker     = "└",
            with_expanders         = true,
            expander_collapsed     = "",
            expander_expanded      = "",
          },
          icon = {
            folder_closed = "",
            folder_open   = "",
            folder_empty  = "󰜌",
          },
          modified = { symbol = "●" },
          git_status = {
            symbols = {
              added     = "",
              modified  = "",
              deleted   = "✖",
              renamed   = "󰁕",
              untracked = "",
              ignored   = "",
              unstaged  = "󰄱",
              staged    = "",
              conflict  = "",
            },
          },
        },
        window = {
          position = "left",
          width    = 35,
          mappings = {
            ["<space>"] = "toggle_node",
            ["<cr>"]    = "open",
            ["s"]       = "open_split",
            ["v"]       = "open_vsplit",
            ["t"]       = "open_tabnew",
            ["C"]       = "close_node",
            ["z"]       = "close_all_nodes",
            ["a"]       = { "add", config = { show_path = "relative" } },
            ["d"]       = "delete",
            ["r"]       = "rename",
            ["y"]       = "copy_to_clipboard",
            ["x"]       = "cut_to_clipboard",
            ["p"]       = "paste_from_clipboard",
            ["c"]       = "copy",
            ["m"]       = "move",
            ["q"]       = "close_window",
            ["R"]       = "refresh",
            ["?"]       = "show_help",
          },
        },
        filesystem = {
          filtered_items = {
            visible        = false,
            hide_dotfiles  = false,
            hide_gitignored = true,
            hide_by_name   = { ".DS_Store", "thumbs.db" },
            never_show     = { ".git" },
          },
          follow_current_file    = { enabled = true },
          use_libuv_file_watcher = true,
        },
        buffers = {
          follow_current_file = { enabled = true },
        },
        git_status = {
          window = { position = "float" },
        },
      })
    end,
  },

  -- ── Fuzzy finder ────────────────────────────────────────
  {
    "nvim-telescope/telescope.nvim",
    branch       = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules", ".git", ".next", "dist", "build", "%.lock"
          },
          layout_config = { horizontal = { preview_width = 0.55 } },
        },
        extensions = {
          ["ui-select"] = { require("telescope.themes").get_dropdown() },
        },
      })
      telescope.load_extension("ui-select")
    end,
  },

  -- ── Treesitter (syntax highlighting) ────────────────────
  -- Uses vim.treesitter (Neovim's built-in API) directly instead of
  -- nvim-treesitter.configs, which avoids the Windows module-not-found crash.
  -- nvim-treesitter is used purely as a parser installer here.
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy  = false,
    dependencies = {
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      -- ── 1. Tell nvim-treesitter which parsers to keep installed ──
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc",
          "javascript", "typescript", "tsx",
          "html", "css", "json", "jsonc",
          "markdown", "markdown_inline",
          "bash", "yaml", "toml", "regex",
          "prisma", "graphql",
        },
        auto_install = true,
        sync_install = false,
      })

      -- ── 2. Enable built-in Neovim treesitter features directly ───
      -- These are stable built-in APIs, no configs submodule needed.
      vim.treesitter.language.register("markdown", "mdx")

      -- Highlight (built-in)
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = "*",
        callback = function(ev)
          local ok = pcall(vim.treesitter.start, ev.buf)
          if not ok then
            -- Gracefully fall back to regex syntax for unsupported filetypes
            vim.bo[ev.buf].syntax = "ON"
          end
        end,
      })

      -- ── 3. Indentation via built-in treesitter indent ─────────────
      vim.api.nvim_create_autocmd("FileType", {
        pattern  = {
          "javascript", "javascriptreact", "typescript", "typescriptreact",
          "html", "css", "json", "lua", "yaml", "tsx",
        },
        callback = function()
          vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
        end,
      })

      -- ── 4. Auto-close / auto-rename JSX tags (nvim-ts-autotag) ───
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close        = true,
          enable_rename       = true,
          enable_close_on_slash = true,
        },
      })

      -- ── 5. Text objects via nvim-treesitter-textobjects ──────────
      -- This module has its own require separate from configs
      local ok_to, textobjects = pcall(require, "nvim-treesitter.textobjects.select")
      if ok_to then
        textobjects.init()
      end

      -- Simpler fallback text-object keymaps using built-in treesitter
      -- (works even if textobjects module fails)
      local ts_utils_ok, _ = pcall(require, "nvim-treesitter.textobjects")
      if not ts_utils_ok then
        -- Minimal function text objects using built-in treesitter nodes
        vim.keymap.set({ "x", "o" }, "af", function()
          vim.cmd("normal! [mvap")
        end, { desc = "Around function (fallback)" })
      end
    end,
  },

  -- ── LSP ─────────────────────────────────────────────────
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },      -- LSP progress UI
      { "folke/neodev.nvim",  opts = {} },      -- Neovim Lua API types
    },
    config = function()
      require("neodev").setup()
      require("mason").setup({ ui = { border = "rounded" } })

      require("mason-tool-installer").setup({
        ensure_installed = {
          -- LSP servers
          "typescript-language-server",
          "tailwindcss-language-server",
          "css-lsp",
          "html-lsp",
          "json-lsp",
          "eslint-lsp",
          "lua-language-server",
          "emmet-ls",
          "prisma-language-server",
          -- Formatters / linters
          "prettierd",
          "eslint_d",
          "stylua",
        },
      })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({})
          end,

          -- TypeScript / JavaScript (Next.js)
          ["tsserver"] = function()
            require("lspconfig").tsserver.setup({
              settings = {
                typescript = {
                  inlayHints = {
                    includeInlayParameterNameHints       = "all",
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints        = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints     = true,
                  },
                },
                javascript = {
                  inlayHints = {
                    includeInlayParameterNameHints       = "all",
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints        = true,
                  },
                },
              },
            })
          end,

          -- Tailwind CSS
          ["tailwindcss"] = function()
            require("lspconfig").tailwindcss.setup({
              filetypes = {
                "html", "css", "javascript", "javascriptreact",
                "typescript", "typescriptreact",
              },
              settings = {
                tailwindCSS = {
                  classAttributes = { "class", "className", "classList", "ngClass" },
                  experimental = { classRegex = {
                    { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                    { "cx\\(([^)]*)\\)",  "[\"'`]([^\"'`]*).*?[\"'`]" },
                  }},
                },
              },
            })
          end,

          -- ESLint LSP
          ["eslint"] = function()
            require("lspconfig").eslint.setup({
              on_attach = function(_, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                  buffer  = bufnr,
                  command = "EslintFixAll",
                })
              end,
            })
          end,

          -- Emmet (HTML / JSX snippets)
          ["emmet_ls"] = function()
            require("lspconfig").emmet_ls.setup({
              filetypes = {
                "html", "css", "typescriptreact", "javascriptreact",
              },
            })
          end,
        },
      })

      -- LSP keymaps (set on every buffer that has an LSP attached)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          local tb = require("telescope.builtin")
          map("gd",         tb.lsp_definitions,       "Go to definition")
          map("gD",         vim.lsp.buf.declaration,   "Go to declaration")
          map("gr",         tb.lsp_references,         "Find references")
          map("gI",         tb.lsp_implementations,    "Go to implementation")
          map("<leader>D",  tb.lsp_type_definitions,   "Type definition")
          map("<leader>ds", tb.lsp_document_symbols,   "Document symbols")
          map("<leader>ws", tb.lsp_workspace_symbols,  "Workspace symbols")
          map("<leader>rn", vim.lsp.buf.rename,         "Rename")
          map("<leader>ca", vim.lsp.buf.code_action,    "Code action")
          map("K",          vim.lsp.buf.hover,          "Hover documentation")
          map("<leader>f",  function() vim.lsp.buf.format({ async = true }) end, "Format buffer")

          -- Show inlay hints if supported
          if vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end
        end,
      })
    end,
  },

  -- ── Autocompletion ──────────────────────────────────────
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",   -- pre-built snippet library
      "onsails/lspkind.nvim",           -- icons in completion menu
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode    = "symbol_text",
            maxwidth = 50,
          }),
        },
        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      -- Cmdline completion
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end,
  },

  -- ── Formatting ──────────────────────────────────────────
  {
    "stevearc/conform.nvim",
    event  = { "BufWritePre" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript      = { { "prettierd", "prettier" } },
          javascriptreact = { { "prettierd", "prettier" } },
          typescript      = { { "prettierd", "prettier" } },
          typescriptreact = { { "prettierd", "prettier" } },
          css             = { { "prettierd", "prettier" } },
          html            = { { "prettierd", "prettier" } },
          json            = { { "prettierd", "prettier" } },
          yaml            = { { "prettierd", "prettier" } },
          markdown        = { { "prettierd", "prettier" } },
          lua             = { "stylua" },
        },
        format_on_save = {
          lsp_fallback = true,
          async        = false,
          timeout_ms   = 1000,
        },
      })
    end,
  },

  -- ── Linting ─────────────────────────────────────────────
  {
    "mfussenegger/nvim-lint",
    event  = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript      = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript      = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        callback = function() lint.try_lint() end,
      })
    end,
  },

  -- ── Git ─────────────────────────────────────────────────
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]c", gs.next_hunk,               "Next hunk")
        map("n", "[c", gs.prev_hunk,               "Prev hunk")
        map("n", "<leader>hs", gs.stage_hunk,      "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk,      "Reset hunk")
        map("n", "<leader>hS", gs.stage_buffer,    "Stage buffer")
        map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>hp", gs.preview_hunk,    "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hd", gs.diffthis,        "Diff this")
        map("n", "<leader>tb", gs.toggle_current_line_blame, "Toggle blame")
      end,
    },
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- ── GitHub Copilot ──────────────────────────────────────
  -- Uncomment if you have a Copilot subscription:
  -- {
  --   "github/copilot.vim",
  --   config = function()
  --     vim.g.copilot_no_tab_map = true
  --     vim.keymap.set("i", "<C-j>", 'copilot#Accept("\\<CR>")', {
  --       expr = true, replace_keycodes = false
  --     })
  --   end,
  -- },

  -- ── Pairs & surround ────────────────────────────────────
  {
    "windwp/nvim-autopairs",
    event  = "InsertEnter",
    config = function()
      local ap  = require("nvim-autopairs")
      local cmp = require("cmp")
      ap.setup({ check_ts = true })
      local cmp_ap = require("nvim-autopairs.completion.cmp")
      cmp.event:on("confirm_done", cmp_ap.on_confirm_done())
    end,
  },

  {
    "kylechui/nvim-surround",
    version = "*",
    event   = "VeryLazy",
    opts    = {},
  },

  -- ── Comments ────────────────────────────────────────────
  {
    "numToStr/Comment.nvim",
    opts = {},
    lazy = false,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = true },
  },

  -- ── Which-key (keybinding help) ─────────────────────────
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init  = function()
      vim.o.timeout    = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  -- ── Diagnostics panel ───────────────────────────────────
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { use_diagnostic_signs = true },
  },

  -- ── Indentation guides ──────────────────────────────────
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope  = { enabled = true },
    },
  },

  -- ── Noice (command / notification UI) ───────────────────
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"]                = true,
          ["cmp.entry.get_documentation"]                  = true,
        },
      },
      presets = {
        bottom_search         = true,
        command_palette       = true,
        long_message_to_split = true,
        inc_rename            = false,
        lsp_doc_border        = true,
      },
    },
  },

  -- ── Terminal inside Neovim ───────────────────────────────
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config  = function()
      require("toggleterm").setup({
        size      = 20,
        open_mapping = [[<C-\>]],
        direction = "float",
        float_opts = { border = "curved" },
        shell        = "C:/Program Files/Git/bin/bash.exe",
      })
    end,
  },

  -- ── Dashboard / start screen ────────────────────────────
  {
    "nvimdev/dashboard-nvim",
    event        = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dashboard").setup({
        theme = "doom",
        config = {
          header = {
            "",
            "  ██╗  ██╗███████╗██╗     ██╗      ██████╗     ███╗   ██╗██╗██╗  ██╗██╗  ██╗██╗██╗     ",
            "  ██║  ██║██╔════╝██║     ██║     ██╔═══██╗    ████╗  ██║██║██║ ██╔╝██║  ██║██║██║     ",
            "  ███████║█████╗  ██║     ██║     ██║   ██║    ██╔██╗ ██║██║█████╔╝ ███████║██║██║     ",
            "  ██╔══██║██╔══╝  ██║     ██║     ██║   ██║    ██║╚██╗██║██║██╔═██╗ ██╔══██║██║██║     ",
            "  ██║  ██║███████╗███████╗███████╗╚██████╔╝    ██║ ╚████║██║██║  ██╗██║  ██║██║███████╗",
            "  ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝ ╚═════╝     ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝",
            "",
          },
          center = {
            { icon = "  ", desc = "Find file",       key = "f", action = "Telescope find_files" },
            { icon = "  ", desc = "Recent files",    key = "r", action = "Telescope oldfiles"   },
            { icon = "  ", desc = "Find text",       key = "g", action = "Telescope live_grep"  },
            { icon = "  ", desc = "File explorer",   key = "e", action = "Neotree toggle"       },
            { icon = "  ", desc = "New file",        key = "n", action = "enew"                 },
            { icon = "  ", desc = "Config",          key = "c", action = "edit $MYVIMRC"        },
            { icon = "  ", desc = "Quit",            key = "q", action = "qa"                   },
          },
          footer = { "", "  Ready to ship the next big thing." },
        },
      })
    end,
  },

  -- ── Highlight word under cursor ─────────────────────────
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex" },
        delay     = 120,
      })
    end,
  },

  -- ── Smooth scrolling ────────────────────────────────────
  { "karb94/neoscroll.nvim", opts = {} },

  -- ── Colour highlighting (#hex, rgb(), etc.) ─────────────
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      user_default_options = {
        tailwind = true,          -- highlight Tailwind class colours
        mode     = "background",
      },
    },
  },

  -- ── Multi-cursor ────────────────────────────────────────
  { "mg979/vim-visual-multi", branch = "master" },

  -- ── Markdown preview ────────────────────────────────────
  {
    "iamcco/markdown-preview.nvim",
    cmd   = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function() vim.fn["mkdp#util#install"]() end,
    ft    = { "markdown" },
  },

  -- ── Notes (obsidian.nvim) ───────────────────────────────
  -- Lightweight markdown-based notes. No external app needed;
  -- notes are plain .md files you can open anywhere.
  -- Vault location: ~/notes  (change to any folder you like)
  -- bash mkdir ~/notes
  -- mkdir ~/notes/daily
  -- mkdir ~/notes/templates
  -- That's C:\Users\Admin\notes on your machine. 
  {
    "epwalsh/obsidian.nvim",
    version      = "*",
    lazy         = false,
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    config = function()
      require("obsidian").setup({
        workspaces = {
          { name = "personal", path = "~/notes" },
        },
        -- Daily notes go into a sub-folder
        daily_notes = {
          folder        = "daily",
          date_format   = "%Y-%m-%d",
          template      = nil,
        },
        -- Use Telescope for note search
        picker = { name = "telescope.nvim" },
        -- Pretty concealment (hides markdown syntax when cursor is elsewhere)
        ui = {
          enable          = true,
          checkboxes = {
            [" "] = { char = "󰄱", hl_group = "ObsidianTodo"     },
            ["x"] = { char = "",  hl_group = "ObsidianDone"     },
            [">"] = { char = "",  hl_group = "ObsidianRightArrow" },
            ["~"] = { char = "󰰱", hl_group = "ObsidianTilde"    },
          },
        },
        -- Note name = title slug
        note_id_func = function(title)
          local suffix = ""
          if title ~= nil then
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end,
        -- Auto-generate frontmatter on new notes
        disable_frontmatter = false,
        templates = {
          subdir     = "templates",
          date_format = "%Y-%m-%d",
          time_format = "%H:%M",
        },
        follow_url_func = function(url)
          vim.fn.jobstart({ "cmd", "/c", "start", url })
        end,
      })
    end,
  },

  -- ── Project management ──────────────────────────────────
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({
        detection_methods = { "pattern", "lsp" },
        patterns          = {
          ".git", "package.json", "next.config.js",
          "next.config.ts", "tsconfig.json",
        },
      })
      require("telescope").load_extension("projects")
    end,
  },

  -- ── Session management ──────────────────────────────────
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts  = { dir = vim.fn.stdpath("state") .. "/sessions/" },
  },

  -- ── Harpoon (fast file switching) ───────────────────────
  {
    "ThePrimeagen/harpoon",
    branch       = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup()
    end,
  },

}, {
  -- Lazy.nvim UI options
  ui = { border = "rounded" },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip", "matchit", "matchparen",
        "netrwPlugin", "tarPlugin", "tohtml", "zipPlugin",
      },
    },
  },
})

-- ── Keymaps ──────────────────────────────────────────────────
local keymap = vim.keymap.set
local opts   = { noremap = true, silent = true }

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize windows
keymap("n", "<C-Up>",    ":resize -2<CR>",          opts)
keymap("n", "<C-Down>",  ":resize +2<CR>",          opts)
keymap("n", "<C-Left>",  ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer navigation
keymap("n", "<S-l>", ":bnext<CR>",     opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>x", ":bd<CR>",   opts)

-- Neo-tree
keymap("n", "<leader>e",  ":Neotree toggle<CR>",                  opts)
keymap("n", "<leader>ef", ":Neotree focus<CR>",                   opts)
keymap("n", "<leader>eg", ":Neotree float git_status<CR>",        opts)
keymap("n", "<leader>eb", ":Neotree toggle buffers right<CR>",    opts)

-- Telescope
local tb = require("telescope.builtin")
keymap("n", "<leader>ff", tb.find_files,                    { desc = "Find files" })
keymap("n", "<leader>fg", tb.live_grep,                     { desc = "Live grep" })
keymap("n", "<leader>fb", tb.buffers,                       { desc = "Buffers" })
keymap("n", "<leader>fh", tb.help_tags,                     { desc = "Help tags" })
keymap("n", "<leader>fo", tb.oldfiles,                      { desc = "Recent files" })
keymap("n", "<leader>fk", tb.keymaps,                       { desc = "Keymaps" })
keymap("n", "<leader>fd", tb.diagnostics,                   { desc = "Diagnostics" })
keymap("n", "<leader>fp", ":Telescope projects<CR>",        { desc = "Projects" })
keymap("n", "<leader>/",  tb.current_buffer_fuzzy_find,     { desc = "Fuzzy find in buffer" })

-- Trouble
keymap("n", "<leader>tt", ":TroubleToggle<CR>",             opts)
keymap("n", "<leader>tw", ":TroubleToggle workspace_diagnostics<CR>", opts)
keymap("n", "<leader>td", ":TroubleToggle document_diagnostics<CR>",  opts)

-- LazyGit
keymap("n", "<leader>gg", ":LazyGit<CR>",                   opts)

-- Harpoon
local harpoon = require("harpoon")
keymap("n", "<leader>ha", function() harpoon:list():add() end,     { desc = "Harpoon add file" })
keymap("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
keymap("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
keymap("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
keymap("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
keymap("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })

-- Session
keymap("n", "<leader>qs", function() require("persistence").load() end,                { desc = "Restore session" })
keymap("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "Restore last session" })

-- Todo comments
keymap("n", "<leader>ft", ":TodoTelescope<CR>", opts)

-- Markdown preview

-- Notes (obsidian.nvim)
-- <leader>nn  new note     <leader>no  open note
-- <leader>nf  find notes   <leader>nd  today's daily note
-- <leader>ns  search text  <leader>nb  backlinks
keymap("n", "<leader>nn", ":ObsidianNew<CR>",          { desc = "New note"          })
keymap("n", "<leader>no", ":ObsidianOpen<CR>",         { desc = "Open in Obsidian"  })
keymap("n", "<leader>nf", ":ObsidianQuickSwitch<CR>",  { desc = "Find note"         })
keymap("n", "<leader>nd", ":ObsidianToday<CR>",        { desc = "Daily note"        })
keymap("n", "<leader>ns", ":ObsidianSearch<CR>",       { desc = "Search notes"      })
keymap("n", "<leader>nb", ":ObsidianBacklinks<CR>",    { desc = "Backlinks"         })
keymap("n", "<leader>nt", ":ObsidianTags<CR>",         { desc = "Browse tags"       })
keymap("n", "<leader>nT", ":ObsidianTemplate<CR>",     { desc = "Insert template"   })
keymap("v", "<leader>nl", ":ObsidianLink<CR>",         { desc = "Link selection"    })
keymap("n", "<leader>mp", ":MarkdownPreviewToggle<CR>", opts)

-- Move lines
keymap("n", "<A-j>", ":m .+1<CR>==",    opts)
keymap("n", "<A-k>", ":m .-2<CR>==",    opts)
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Keep indent in visual mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Paste without overwriting register
keymap("v", "p", '"_dP', opts)

-- Clear search highlight
keymap("n", "<Esc>", ":noh<CR>", opts)

-- Save
keymap("n", "<C-s>", ":w<CR>",   opts)
keymap("i", "<C-s>", "<Esc>:w<CR>", opts)

-- Quit
keymap("n", "<leader>q", ":q<CR>",  opts)
keymap("n", "<leader>Q", ":qa!<CR>", opts)

-- ── Autocommands ─────────────────────────────────────────────
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  group    = augroup("YankHighlight", { clear = true }),
  callback = function() vim.highlight.on_yank() end,
})

-- Auto-resize splits when the window is resized
autocmd("VimResized", {
  group    = augroup("ResizeSplits", { clear = true }),
  callback = function() vim.cmd.tabdo("wincmd =") end,
})

-- Trim trailing whitespace on save (JS/TS files)
autocmd("BufWritePre", {
  group   = augroup("TrimWhitespace", { clear = true }),
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- Set filetype for Next.js config files
autocmd({ "BufRead", "BufNewFile" }, {
  group   = augroup("NextjsFiletypes", { clear = true }),
  pattern = { "*.mdx" },
  command = "set filetype=markdown",
})

-- ── Diagnostics appearance ───────────────────────────────────
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    source = "if_many",
  },
  severity_sort = true,
  float         = { border = "rounded", source = "always" },
})

vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",  { text = " ", texthl = "DiagnosticSignWarn"  })
vim.fn.sign_define("DiagnosticSignInfo",  { text = " ", texthl = "DiagnosticSignInfo"  })
vim.fn.sign_define("DiagnosticSignHint",  { text = "󰠠 ", texthl = "DiagnosticSignHint"  })
