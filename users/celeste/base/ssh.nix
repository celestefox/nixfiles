{lib, ...}:
with lib; let
  personalHost = {
    port = 62954;
    forwardAgent = true;
    forwardX11 = true;
    forwardX11Trusted = true;
    # TODO: get this actually working? this is difficult since I need to know where the remote host's `gpg` expects the socket, in the config here
    # This is mostly obvious when I have, as i do in practice, different UIDs - I need to know what the UID is on the server statically, really, here?
    # Going to try using %i, locally, and hardcode remote to 1000 - it's correct for star, and the default value...
    extraOptions.RemoteForward = "/run/user/1000/gnupg/S.gpg-agent /run/user/%i/gnupg/S.gpg-agent.extra";
  };
in {
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
    compression = true;
    includes = ["config_local"];
    matchBlocks = {
      # TODO: still needed for deploys, see about actually using deploy-rs soon?
      "star" = personalHost // {hostname = "star.wg.foxgirl.tech";};
      "star.foxgirl.tech" = personalHost;
      "star.wg.foxgirl.tech" = personalHost;
      "shiro.int.foxgirl.tech" = {
        user = "Kitsune"; # wow! a kitsune!
        port = 22;
        forwardAgent = true; # it's windows, so this is the only useful part of personalHost?
      };
      # good for testing auth... don't use it for git remotes, tho, unless you'll keep this setting, and even then... shrug
      "github.com".user = "git";
      "gitlab.com".user = "git";
      # if sshing to localhost, it's a personal host
      # ideally maybe a username, but this forces loopback netrworking at worst
      "localhost" = personalHost;
    };
  };
}
