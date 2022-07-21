{ pkgs, ... }: {
  # Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprintBin
      hplip
      #cups-googlecloudprint
    ];
    browsing = true;
  };
}
