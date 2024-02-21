{pkgs, ...}: {
  # Install language servers and other generally wanted tools globally
  home.packages = with pkgs; [
    neovim-remote
    page
    neovim-qt-unwrapped
    neovide
  ];

  # Neovim
  programs.neovim = {
    enable = true;
    extraPackages = builtins.attrValues {inherit (pkgs) nil alejandra nixpkgs-fmt xclip lua-language-server iferr fennel-ls;};
    extraLuaPackages = lp: builtins.attrValues {inherit (lp) jsregexp;}; # for luasnip
    /*
    because for some reason, home manager doesn't join the three bits of lua config with newlines... i can use the middle one to insert one nicely
    i mean, maybe because things seemed to still work okay, but it at least always looks wrong... probably yet another reason i should drop this setup
    mostly because i'd really like to actually get to edit lua files, really, also, heck, the rebuild cycle is very slow for editor configs imo/ime
    (reason to do deploy-rs finally too? (separate user vs machine deploys (to a degree?)))
    */
    extraLuaConfig = "\n";
    plugins = with pkgs.vimPlugins; let
      ex = pkgs.vimExtraPlugins;
    in [
      vim-sensible
      {
        plugin = hotpot-nvim;
        type = "lua";
        config = ''
          require'hotpot'.setup{
            provide_require_fennel = true,
            -- enable automatic attachment of diagnostics to fennel buffers
            enable_hotpot_diagnostics = true,
            compiler = {
              -- options passed to fennel.compile for modules, defaults to {}
              modules = {
                -- not default but recommended, align lua lines with fnl source
                -- for more debuggable errors, but less readable lua.
                correlate = true,
              },
            },
          }
          -- wip
          require'direnv' --.setup{}
        '';
      }
      vim-unimpaired
      {
        plugin = nvim-surround;
        type = "lua";
        config = ''
          require'nvim-surround'.setup{}
        '';
      }
      plenary-nvim
      {
        plugin = vim-numbertoggle;
        type = "lua";
        config = ''
          -- Default to both number and relative number
          vim.opt.number = true
          vim.opt.relativenumber = true
        '';
      }
      {
        plugin = guess-indent-nvim;
        type = "lua";
        config = ''
          require'guess-indent'.setup{}
        '';
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            local rainbowhl = {
              "RainbowRed",
              "RainbowOrange",
              "RainbowYellow",
              "RainbowGreen",
              "RainbowCyan",
              "RainbowBlue",
              "RainbowViolet",
            }

            local iblhooks = require'ibl.hooks'

            iblhooks.register(iblhooks.type.HIGHLIGHT_SETUP, function()
              vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
              vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
              vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
              vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
              vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
              vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
              vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
            end)

            require'ibl'.setup{
              indent = {
                highlight = rainbowhl,
              },
              scope = {
                char = '▌',
              },
            }
          '';
      }
      vim-eunuch
      zoxide-vim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            -- Mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions
            local opts = { noremap=true, silent=true }
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

            -- Use an on_attach function to only map the following keys
            -- after the language server attaches to the current buffer
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

            -- capabilities for nvim-cmp
            local lsp = require'lspconfig'
            lsp.util.default_config = vim.tbl_deep_extend("force", lsp.util.default_config, {
              capabilities = require'cmp_nvim_lsp'.default_capabilities(),
            })

            -- mow
            --vim.lsp.set_log_level("debug")

            lsp.nil_ls.setup{
              settings = {
                ['nil'] = {
                  formatting = {
                    command = { "alejandra", "-" },
                  },
                },
              },
              on_attach=on_attach,
            }

            lsp.pylsp.setup{
              on_attach=on_attach,
            }

            -- Tuned for editing lua for nvim, if I do do that. Override w/ a .luarc.json for projects if needed
            -- https://github.com/sumneko/lua-language-server/wiki/Configuration-File
            -- lua-language-server now, but looks the same there: https://github.com/LuaLS/lua-language-server/wiki/Configuration-File
            lsp.lua_ls.setup{
              settings = {
                Lua = {
                  runtime = {
                    -- What version of Lua (Neovim Lua is probably LuaJIT), is as of setting this up
                    version = 'LuaJIT',
                  },
                  diagnostics = {
                    -- recognise the vim global
                    globals = {'vim'},
                  },
                  workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true)
                  },
                  telemetry = {
                    enable = false,
                  },
                },
              },
              on_attach=on_attach,
            }

            lsp.fennel_ls.setup{
              on_attach=on_attach,
            }

            lsp.denols.setup{
              on_attach=on_attach,
              root_dir = lsp.util.root_pattern("deno.json", "deno.jsonc"),
            }
          '';
      }
      {
        plugin = rust-vim;
        type = "lua";
        config = '''';
      }
      {
        plugin = rust-tools-nvim;
        type = "lua";
        config = ''
          require'rust-tools'.setup{
            server = {
              on_attach = function(client, bufnr)
                -- TODO: This is copied from above w/ additions: make modular? Maybe a "require" for an extensible "on_attach" function?
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

                -- Rust specific
                -- Hover actions
                vim.keymap.set("n", "<C-space>", require'rust-tools'.hover_actions.hover_actions, bufopts)
                -- Code action groups
                vim.keymap.set("n", "<space>cg", require'rust-tools'.code_action_group.code_action_group, bufopts)
              end,
            },
          }
        '';
      }
      pkgs.vimExtraPlugins.guihua-lua
      {
        plugin = pkgs.vimExtraPlugins.go-nvim;
        type = "lua";
        config = ''
          require'go'.setup{
            verbose = true,
            lsp_cfg = {
              -- capabilities = require'cmp_nvim_lsp'.default_capabilities(),
            },
            lsp_on_attach = true,
            lsp_keymaps = function(bufnr)
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
              vim.keymap.set('n', '<space>rn', function() require'go.rename'.run() end, bufopts)
              vim.keymap.set('n', '<space>ca', function() require'go.codeaction'.run_code_action() end, bufopts)
              vim.keymap.set('v', '<space>ca', function() require'go.codeaction'.run_range_code_action() end, bufopts)
              vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
              vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
            end,
            lsp_gofumpt = true,
            textobjects = false,
            luasnip = true,
          }
        '';
      }
      /*
      {
        plugin = pkgs.vimExtraPlugins.nvim-go;
        type = "lua";
        config = ''
          -- lsp config is in lspconfig plugin block, since there's no need to put it here
          -- binaries this wants, really:
          -- gopls, language server
          -- revive, linter
          -- gomodifytags
          -- gotests
          -- iferr (including)
          -- nodePackages.quicktype
          require'go'.setup{
            formatter = 'lsp',
          }

        '';
      }
      */
      {
        plugin = pkgs.vimExtraPlugins.typescript-nvim;
        type = "lua";
        config = ''
          require'typescript'.setup{
            server = {
              on_attach = function(client, bufnr)
                -- TODO: This is copied from above w/ additions: make modular? Maybe a "require" for an extensible "on_attach" function?
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
              end,
              root_dir = lsp.util.root_pattern("package.json"), -- don't match tsconfig because deno
              single_file_support = false, -- TODO: same, but testing needed still
            },
          }
        '';
      }
      # completion
      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-git
      # for luasnip integration
      cmp_luasnip
      # pretty
      lspkind-nvim
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          vim.opt.completeopt = { "menu", "menuone", "noselect" }

          local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
          end

          local luasnip = require'luasnip'
          local cmp = require'cmp'
          local lspkind = require'lspkind'

          cmp.setup{
            snippet = {
              expand = function(args)
                require'luasnip'.lsp_expand(args.body)
              end,
            },
            window = {
            },
            formatting = {
              format = lspkind.cmp_format{
                mode = "symbol_text",
                menu = ({
                  buffer = "[Buffer]",
                  nvim_lsp = "[LSP]",
                  luasnip = "[LuaSnip]",
                  nvim_lua = "[Lua]",
                  latex_symbols = "[Latex]",
                }),
              },
            },
            -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/mapping.lua#L36
            -- summary: C-n next C-p prev C-y select C-e escape
            mapping = cmp.mapping.preset.insert{
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-Space>'] = cmp.mapping.complete(),
              ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                -- they way you will only jump inside the snippet region
                elseif luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s" }),
              ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
              -- ['<CR>'] = cmp.mapping{
              --   i = function(fallback)
              --     if cmp.visible() and cmp.get_active_entry() then
              --       cmp.confirm{ behavior = cmp.ConfirmBehavior.Replace, select = false }
              --     else
              --       fallback()
              --     end
              --   end,
              --   s = cmp.mapping.confirm{ select = true },
              --   c = cmp.mapping.confirm{ behavior = cmp.ConfirmBehavior.Replace, select = true },
              -- },
              ['<C-e>'] = cmp.mapping(function(fallback)
                if luasnip.choice_active() then
                  luasnip.change_choice(1)
                elseif not cmp.abort() then
                  fallback()
                end
              end, { "i", "s" }),
            },
            sources = cmp.config.sources({
              { name = 'nvim_lsp' },
              { name = 'nvim_lsp_signature_help' },
              { name = 'luasnip' },
            }, {
              { name = 'buffer' },
            }),
          }

          -- Set configuration for specific filetype.
          cmp.setup.filetype('gitcommit', {
            sources = cmp.config.sources({
              { name = 'cmp_git' },
            }, {
              { name = 'buffer' },
            })
          })

          -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
              { name = 'buffer' }
            }
          })

          -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
          cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
              { name = 'path' }
            }, {
              { name = 'cmdline' }
            })
          })
        '';
      }
      # snippets
      {
        plugin = luasnip;
        type = "lua";
        config = ''
          local ls = require'luasnip'

          ls.setup{
            ft_func = require'luasnip.extras.filetype_functions'.from_pos_or_filetype,
            load_ft_func = require'luasnip.extras.filetype_functions'.extend_load_ft{
              html = {"javascript"}
            },
          }

          -- For vim-snippets
          ls.filetype_extend("all", { "_" })
          -- as a note: https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua
          -- from_pos_or_filetype above preferentially returns the name of the treesitter parser
          ls.filetype_extend("latex", { "tex" })

          -- Loaders
          require'luasnip.loaders.from_vscode'.lazy_load{}
          require'luasnip.loaders.from_snipmate'.lazy_load{}
          require'luasnip.loaders.from_lua'.lazy_load{paths = vim.fn.stdpath'config' .. "/snippets"}

          vim.api.nvim_create_user_command('LuaSnipEdit', function(opts)
            require'luasnip.loaders'.edit_snippet_files{
              extend = function(ft, paths)
                if #paths == 0 then
                  return {
                    { "$CONFIG/snippets/" .. ft .. ".snippets",
                    string.format("%s/snippets/%s.snippets", vim.fn.stdpath('config'), ft) }
                  }
                end
                return {}
              end,
            }
          end, {})
        '';
      }
      vim-snippets
      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
          require'Comment'.setup{
            pre_hook = require'ts_context_commentstring.integrations.comment_nvim'.create_pre_hook(),
          }
        '';
      }
      # treesitter syntax highlighting and the closest integrations
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require'nvim-treesitter.configs'.setup{
            -- Don't auto install on NixOS
            auto_install = false,
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
           indent = {
              enable = true,
            },
            playground = {
              enable = true,
            },
            matchup = {
              enable = true,
            },
          }
        '';
      }
      {
        plugin = nvim-ts-context-commentstring;
        type = "lua";
        config = ''
          require'ts_context_commentstring'.setup{
            enable_autocmd = false,
          }
        '';
      }
      {
        plugin = nvim-treesitter-context;
        type = "lua";
        config = ''
          require'treesitter-context'.setup{}
        '';
      }
      pkgs.vimExtraPlugins.vim-matchup # docs suggest it should be loaded before sensible for vim, but doesn't matter for neovim? so it's here, since the only config'd bit is treesitter
      {
        plugin = splitjoin-vim;
        type = "lua";
        config = ''
          -- disable the default splitjoin mappings, it's used as fallback for treesj below
          vim.g.splitjoin_split_mapping = ""
          vim.g.splitjoin_join_mapping = ""
        '';
      }
      {
        plugin = treesj;
        type = "lua";
        config = ''
          require'treesj'.setup{
            use_default_keymaps = false,
          }

          -- https://github.com/Wansmer/treesj/discussions/19
          local langs = require'treesj.langs'['presets']

          vim.api.nvim_create_autocmd({ 'FileType' }, {
            pattern = '*',
            callback = function()
              local opts = { buffer = true }
              if langs[vim.bo.filetype] then
                vim.keymap.set('n', 'gS', '<Cmd>TSJSplit<CR>', opts)
                vim.keymap.set('n', 'gJ', '<Cmd>TSJJoin<CR>', opts)
              else
                vim.keymap.set('n', 'gS', '<Cmd>SplitjoinSplit<CR>', opts)
                vim.keymap.set('n', 'gJ', '<Cmd>SplitjoinJoin<CR>', opts)
              end
            end,
          })
        '';
      }
      # autopair
      {
        plugin = ex.nvim-autopairs;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            local npairs = require'nvim-autopairs'
            local cmp_ap = require'nvim-autopairs.completion.cmp'
            local ts_utils = require'nvim-treesitter.ts_utils'
            local Rule = require'nvim-autopairs.rule'
            local np_conds = require'nvim-autopairs.conds'
            local ts_conds = require'nvim-autopairs.ts-conds'

            npairs.setup{
              check_ts = true,
            }

            cmp.event:on(
              "confirm_done",
              cmp_ap.on_confirm_done()
            )

            -- nix indented strings
            -- conditions explained:
            -- context: don't run in injections, which includes comments
            -- not ts node: prevents it in string contents (comment as redundancy too)
            -- not after/before text: mainly for edge cases around these strings:
            -- if you're in one and type 2x' context is back to nix and not string node
            -- so a third, which you probably want to type because it escapes an actual 2x'
            -- triggers the rule, leaving you with another 2, or 5 in a row. this might
            -- be overkill on the rules, but it seems to work well for now
            -- is annoying to try to talk about this in a context where the escaping you are
            -- talking about is active, so you gotta do things like 3x', >.<
            npairs.add_rules{
              Rule("'''","'''",{"nix"})
                :with_pair(ts_conds.is_not_in_context())
                :with_pair(ts_conds.is_not_ts_node{'string_fragment','comment'})
                :with_pair(np_conds.not_after_text"'''")
                :with_pair(np_conds.not_before_text"'''"),
            }

            -- and disable the single ' rule for nix (it is already not rust by default because
            -- there's a rust specific single quote rule, so that stays in too)
            npairs.get_rules"'"[1].not_filetypes = {'rust','nix'}
          '';
      }
      # Pretty quickfix
      {
        plugin = pkgs.vimExtraPlugins.nvim-pqf;
        type = "lua";
        config = ''
          require'pqf'.setup{}
        '';
      }
      # Git
      vim-fugitive
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require'gitsigns'.setup{}
        '';
      }
      {
        plugin = gitlinker-nvim;
        type = "lua";
        config = ''
          require'gitlinker'.setup{
            callbacks = {
              ["star.foxgirl.tech"] = function(url_data)
                url_data.host = "git.foxgirl.tech"
                url_data.port = nil
                return require'gitlinker.hosts'.get_gitea_type_url(url_data)
              end,
            },
          }
        '';
      }
      {
        plugin = diffview-nvim;
        type = "lua";
        config = ''
          require'diffview'.setup{}
        '';
      }
      {
        plugin = neogit;
        type = "lua";
        config = ''
          require'neogit'.setup{}
        '';
      }
      # Telescope
      ## sorter
      telescope-zf-native-nvim
      ## pickers/etc
      telescope-file-browser-nvim
      ex.telescope-repo-nvim
      ex.telescope-undo-nvim
      telescope-zoxide
      ## telescope itself and config
      {
        plugin = telescope-nvim;
        type = "lua";
        config =
          /*
          lua
          */
          ''
            -- telescope
            require'telescope'.setup{
              defaults = {
                layout_strategy = 'horizontal',
                layout_config = {
                  horizontal = {
                    width = 0.9,
                  },
                },
              },
              extensions = {
                repo = {
                  list = {
                    fd_opts = {
                      '--no-ignore-vcs',
                    },
                  },
                },
                zoxide = {
                  mappings = {
                    ['<C-f>'] = {
                      keepinsert = true,
                      action = function(selection)
                        -- our change: cd to the path for this bind
                        vim.cmd.cd(selection.path)
                        require'telescope.builtin'.find_files()
                      end
                    },
                    ['<C-b>'] = {
                      keepinsert = true,
                      action = function(selection)
                        require'telescope'.extensions.file_browser.file_browser{ path = selection.path }
                      end
                    },
                  },
                },
              },
            }
            -- load the extensions
            require'telescope'.load_extension'zf-native'
            require'telescope'.load_extension'file_browser'
            require'telescope'.load_extension'repo'
            require'telescope'.load_extension'undo'
            require'telescope'.load_extension'zoxide'
            -- binds
            vim.keymap.set('n', '<leader>zo', function() require'telescope'.extensions.zoxide.list() end, {})
            vim.keymap.set('n', '<leader>cd', function() require'telescope'.extensions.zoxide.list() end, {})
            vim.keymap.set('n', '<leader>fd', function() require'telescope.builtin'.find_files() end, {})
            vim.keymap.set('n', '<leader>fb', function() require'telescope'.extensions.file_browser.file_browser() end, {})
            vim.keymap.set('n', '<leader>gr', function() require'telescope'.extensions.repo.list() end, {})
            vim.keymap.set('n', '<leader>u', function() require'telescope'.extensions.undo.undo() end, {})
          '';
      }
      # hologram - kitty protocol image display
      {
        plugin = hologram-nvim;
        type = "lua";
        config = ''
          require'hologram'.setup{}
        '';
      }
      # Themes
      {
        plugin = ex.starry-nvim;
        type = "lua";
        config = ''
          vim.opt.termguicolors = true
          require'starry'.setup{
            italics = {
              comments = true,
            },
            disable = {
              background = true,
            },
            style = {
              name = 'moonlight', -- hmm...
            },
          }
          vim.cmd.colorscheme 'moonlight'
        '';
      }
      {
        plugin = nvim-web-devicons;
        type = "lua";
        config = ''
          require'nvim-web-devicons'.setup{}
        '';
      }
      {
        plugin = aurora;
        type = "lua";
        config = ''
          vim.g.aurora_italic = 1
          vim.g.aurora_transparent = 1
          -- vim.cmd.colorscheme 'aurora'
        '';
      }
    ];
    extraConfig = ''
      if exists("g:neovide")
        " Running in neovide
        set guifont=VictorMono\ Nerd\ Font,Fira\ Code\ Nerd\ Font,Fira\ Code:h10
        let g:neovide_transparency = 0.8
        let g:neovide_remember_window_size = v:true
        let g:neovide_cursor_vfx_mode = "pixiedust"
      endif
    '';
  };
}
