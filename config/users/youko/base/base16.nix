{ config, ... }:

{
  base16 = {
    # SETUP Change scheme, alias
    shell.enable = true;
    schemes = [ "atelier.atelier-cave" "atelier.atelier-cave-light" "tomorrow.tomorrow-night-eighties" "tomorrow.tomorrow" ];
    alias.light = "atelier.atelier-cave-light";
    alias.dark = "atelier.atelier-cave";
  };

  kw.theme.enable = true;
}
