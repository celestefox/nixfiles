{ lib, pkgs, ... }: with lib; let
  # the synthwave ext to reference
  synthwave = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "synthwave-vscode";
      publisher = "RobbOwen";
      version = "0.1.11";
      sha256 = "1r2qqlm3alb9ysjiyaqakd01r87kmns8y1qfndv6v24aj2l3syww";
    };
    meta = {
      license = lib.licenses.mit;
    };
  };
  # build patched vscode
  #vscode-patched = { };
in
{
  programs.vscode = {
    enable = true;
    #package = vscode-patched;
    #extensions = [ synthwave ];
  };
}
