{ lib, pkgs, config, inputs, users, treated, profiles, ... }: with lib; {
  # Imports! mew
  imports = [
    # wsl
    profiles.wsl
  ];
  # Hostname! heckin mess of nixy stuff
  networking.hostName = "okami";

  # TZ
  time.timeZone = "America/Denver";

  # Locales (minimal)
  i18n.defaultLocale = "en_US.UTF-8"; # is default anyways but
  i18n.supportedLocales = [ (config.i18n.defaultLocale + "/UTF-8") ];

  users.users.youko.group = "users";
  users.users.youko.isNormalUser = true;

  # Home manager
  home-manager = {
    users.youko = { imports = singleton users.youko; };
    /* beautiful... but I want only youko only here
    users = mapAttrs (_: user: {
      imports = singleton user;
    }) users;
    */
  };

  # Fix up VSCode remote server
  services.vscode-server.enable = true;

  # System state version, be careful changing
  system.stateVersion = "22.05";
}
