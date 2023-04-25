{ inputs, ... }: {
  nixpkgs = {
    overlays = [
      (import "${inputs.arcexprs}/overlay.nix")
      inputs.ragenix.overlays.default
      inputs.nixneovimplugins.overlays.default
    ];
    config = {
      allowUnfree = true;
      allowBroken = true; # vimExtraPlugins.go-nvim
    };
  };
}
