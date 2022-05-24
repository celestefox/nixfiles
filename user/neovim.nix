{ pkgs, ... }: {
  # Install language servers and other generally wanted tools globally
  home.packages = with pkgs; [
    rnix-lsp nixpkgs-fmt
  ];

  # Neovim
  programs.neovim = {
    enable = true;
    plugins = (with pkgs.vimPlugins; [
      vim-sensible
      vim-eunuch
      vim-nix
      { plugin = nvim-lspconfig; type = "lua"; config = ''
        require'lspconfig'.rnix.setup{}
      ''; }
    ]);
  };
}