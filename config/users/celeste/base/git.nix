{ config, pkgs, lib, ... }:

{
  # SETUP Change this
  home.packages = with pkgs; [
    git-crypt
    gitAndTools.gitRemoteGcrypt
    gitAndTools.gitAnnex
    git-revise
    gitAndTools.git-annex-remote-b2
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Celeste Fox";
    userEmail = "celeste@foxgirl.tech";
    extraConfig = {
      init = { defaultBranch = "main"; };
      protocol.gcrypt.allow = "always";
      annex = {
        autocommit = false;
        backend = "BLAKE2B512";
        synccontent = true;
      };
    };
    signing = {
      key = "361D4D533A25164A";
      signByDefault = false;
    };
  };
}
