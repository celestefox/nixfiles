{ ... }: {
  # docs please
  documentation.enable = true;
  documentation.nixos.enable = true;
  documentation.nixos.options.warningsAreErrors = false;
  #documentation.nixos.includeAllModules = true;
  programs.command-not-found.enable = false; # depends on channels
}