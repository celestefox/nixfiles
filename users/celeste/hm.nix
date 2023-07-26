{users, ...}: {
  # import defaults
  imports = [
    users.celeste.base
  ];
  # Home config
  home.username = "celeste";
  home.homeDirectory = "/home/celeste";

  # persistence
  /*
  home.persistence."/persist/home/celeste" = {
    directories = [
      # configs
      ".gnupg"
      ".ssh"
      # TODO: more specific than these
      #".local"
      #".config"
      ".local/share/fish"
      ".local/share/keyrings"
      ".local/share/direnv"
      ".mozilla"
      # stuff
      "docs"
      "media"
      "mail"
      "projects"
    ];
    allowOther = true;
  };
  */

  # mew
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
