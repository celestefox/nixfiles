{
  config,
  lib,
  pkgs,
  ...
}: {
  # Now global, from profiles/base/rclone
  #home.packages = lib.singleton pkgs.rclone;
  systemd.user.mounts = let
    rcloneOf = {
      path,
      remoteName,
      remotePath,
      remote ? "${remoteName}:${remotePath}",
      config ? "%h/.config/rclone/rclone.conf",
      extra_opts ? [],
      ...
    } @ args: {
      Unit = {
        Description = "Mount rclone remote ${remote}";
      };
      Mount = {
        Type = "rclone";
        What = remote;
        Where = path;
        Options =
          [
            "rw"
            "_netdev"
            "allow_other"
            "args2env"
            "vfs-cache-mode=writes"
            "config=${config}"
            "cache-dir=%C/rclone/${remoteName}" # name only - : in filenames questionable, etc
            "vvvv"
            "log-file=%L/rclone/${remoteName}.log"
            "log-level=DEBUG"
          ]
          ++ extra_opts;
        # note that places like https://github.com/NixOS/nixpkgs/issues/96928 suggest :$PATH, but man systemd.exec says
        # "Variable expansion is not performed inside the strings and the "$" character has no special meaning."
        # - but `systemd-run --user -P env` shows a PATH with only a systemd derivation's bin, so it's probably fine
        # after all, the extra version that probably kept a literal $PATH others said worked for them, after all
        Environment = ["PATH=/run/wrappers/bin"];
      };
    };
  in {
    # TODO: automatic mapping to systemd escaped name?
    "home-celeste-uploads" = rcloneOf {
      remoteName = "uploads";
      remotePath = "celeste-uploads";
      path = "%h/uploads";
    };
  };
  systemd.user.tmpfiles.rules = [
    "d %h/uploads 0755 - - - -"
    "d %L/rclone 0755 - - - -"
  ];
}
