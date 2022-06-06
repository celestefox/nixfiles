{ config, ... }:

{
  base16 = {
    schemes = [ "tomorrow.tomorrow-night-eighties" ];
    # SETUP Change scheme
    console = {
      enable = true;
      schemeName = "tomorrow.tomorrow-night-eighties";
    };
  };
}
