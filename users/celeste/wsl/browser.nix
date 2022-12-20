{ config, lib, pkgs, ... }: with lib; let
in
{
  home.packages = [ pkgs.wsl-open ];
  home.sessionVariables = {
    BROWSER = "wsl-open";
  };
}