{ inputs, ... }: {
  nixpkgs = {
    overlays = [
      (import "${inputs.arcexprs}/overlay.nix")
      inputs.ragenix.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };
}
