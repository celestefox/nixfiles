{
  config,
  pkgs,
  lib,
  ...
}: {
  base16 = {
    vim.enable = false; # TODO: neovim?
    shell.enable = false;
    schemes = {
      dark = "rose-pine.rose-pine-moon";
      light = "rose-pine.rose-pine-dawn";
    };
    defaultSchemeName = "dark";
  };
}
