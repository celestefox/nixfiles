let
  optionalAttrs = cond: as: if cond then as else {};
  # Sources are from niv.
  sources = import ./nix/sources.nix // optionalAttrs (builtins.pathExists ./pkgs/exprs/default.nix) {
    katexprs = ./pkgs/exprs;
  };
  # We pass sources through to pkgs and get our nixpkgs + overlays.
  pkgs = import ./pkgs { inherit sources; };
  # We want our overlaid lib.
  inherit (pkgs) lib;
  # This is used for caching niv sources in CI.
  sourceCache = import ./cache.nix { inherit sources lib; };
  # This is used for the base path for hostImport.
  root = ./.;

  /*
  This is used to generate specialArgs + the like. It works as such:
    * A <subconfigName> can exist at config/<subconfigName>.
  */
  subconfigNames = lib.folderList ./config [];
  subconfig = lib.mapListToAttrs (folder: lib.nameValuePair folder (lib.domainMerge {
    inherit folder;
    folderPaths = [ (./config + "/${folder}") ];
  })) subconfigNames;

  /*
  We use this to make the meta runner use this file and to use `--show-trace` on nix-builds.
  We also pass through pkgs to meta this way.
  */
  metaConfig = import ./meta.nix {
    inherit pkgs lib subconfig;
  };

  # This is where the meta config is evaluated.
  eval = lib.evalModules {
    modules = lib.singleton metaConfig
    #++ lib.attrValues subconfig.hosts
    ++ (map (host: {
      network.nodes.${host} = {
        imports = config.lib.kw.nodeImport host;
      };
    }) (lib.attrNames subconfig.hosts))
    ++ lib.singleton ./config/modules/meta/default.nix;

    specialArgs = {
      inherit sources root;
      meta = self;
    } // subconfig;
  };

  # The evaluated meta config.
  inherit (eval) config;

/*
  Please note all specialArg generated specifications use the folder common to both import paths.
  Those import paths are as mentioned above next to `subconfigNames`.

  This provides us with a ./. that contains (most relevantly):
    * deploy.targets -> a mapping of target name to host names
    * network.nodes -> host names to host NixOS + home-manager configs
    * profiles -> the specialArg generated from profiles/
    * users -> the specialArg generated from users/
    * targets -> the specialArg generated from targets/
      * do not use common, it is tf-nix specific config ingested at line 66 of config/modules/meta/deploy.nix for every target.
    * services -> the specialArg generated from services/
*/
  self = config // { inherit pkgs lib sourceCache sources; } // subconfig;
in self
