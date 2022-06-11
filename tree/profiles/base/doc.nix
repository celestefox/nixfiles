{ ... }: {
  # docs please
  documentation.enable = true;
  documentation.nixos.enable = true;
  programs.command-not-found.enable = false; # depends on channels
}