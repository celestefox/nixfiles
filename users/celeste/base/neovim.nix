{ pkgs, ... }: {
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
    extraPackages = builtins.attrValues { inherit (pkgs) rnix-lsp nixpkgs-fmt xclip; };
    plugins = (with pkgs.vimPlugins; [
      vim-sensible
      vim-eunuch
      vim-nix
      zoxide-vim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
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

          -- mow
          --vim.lsp.set_log_level("debug")

          require'lspconfig'.rnix.setup{
            on_attach=on_attach,
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
                vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, bufopts)
                -- Code action groups
                vim.keymap.set("n", "<space>cg", rt.code_action_group.code_action_group, bufopts)
              end,
            },
          }
        '';
      }
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require'nvim-treesitter.configs'.setup{
            -- Don't auto install on NixOS
            auto_install = false,
          }
        '';
      }
      # Themes
      {
        plugin = aurora;
        type = "lua";
        config = ''
          vim.opt.termguicolors = true
          vim.g.aurora_italic = 1
          vim.g.aurora_transparent = 1
          vim.cmd.colorscheme 'aurora'
        '';
      }
    ]);
    extraConfig = ''
      if exists("g:neovide")
        " Running in neovide
        set guifont=VictorMono\ NF,Victor\ Mono,Fira\ Code\ NF,Fira\ Code:h12
        let g:neovide_transparency = 0.8
        let g:neovide_remember_window_size = v:true
        let g:neovide_cursor_vfx_mode = "pixiedust"
      endif
    '';
  };
}
