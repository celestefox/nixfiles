{ config, ... }:

{
  base16 = {
    schemes = [ "rebecca.rebecca" ];
    # SETUP Change scheme
    console = {
      enable = true;
      schemeName = "rebecca.rebecca";
    };
  };
}
