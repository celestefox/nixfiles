{ inputs, ... }: [
  (import "${inputs.arcexprs}/overlay.nix")
  inputs.ragenix.overlay
]