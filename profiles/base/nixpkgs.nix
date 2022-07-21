{ overlays, ... }: {
  nixpkgs = {
    # nixfiles/overlays.nix
    inherit overlays;
    config = {
      allowUnfree = true;
    };
  };
}