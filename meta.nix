{ pkgs, lib, ... }: {
  config = {
    runners = {
      lazy = {
        file = ./.;
        args = [ "--show-trace" "--extra-sandbox-paths" "/var/run/nscd/socket=/var/run/nscd/socket" ];
      };
    };
    _module.args = {
      pkgs = lib.mkDefault pkgs;
    };
  };
}
