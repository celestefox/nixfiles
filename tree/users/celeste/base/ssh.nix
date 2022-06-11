{ ... }: {
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "cirno" = {
        hostname = "138.68.59.195";
        user = "youko";
      };
    };
  };
}
