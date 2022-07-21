{ pkgs, ... }: {
  # Keyring
  services.gnome-keyring = {
    enable = true;
    # I believe I only want secrets as I have gpg-agent handling pkcs11 and ssh?
    components = [ "secrets" ];
  };
  home.packages = with pkgs; [ gnome.seahorse ];
}
