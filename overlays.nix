{
  inputs,
  tree,
  ...
}:
[
  inputs.ragenix.overlays.default
  inputs.nixneovimplugins.overlays.default
  inputs.deploy-rs.overlay
  (import tree.packages.default {inherit inputs tree;})
]
++ map (path: import "${path}/overlay.nix") [
  inputs.arcexprs
]
