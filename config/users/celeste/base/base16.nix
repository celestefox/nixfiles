{ config, ... }:

{
  base16 = {
    # SETUP Change scheme, alias
    shell.enable = true;
    schemes = [ "atelier.atelier-cave" "atelier.atelier-cave-light" "tomorrow.tomorrow-night-eighties" "tomorrow.tomorrow" ];
    alias.light = "tomorrow.tomorrow-night-eighties";
    alias.dark = "tomorrow.tomorrow-night-eighties";
  };

  kw.theme.enable = true;
}
