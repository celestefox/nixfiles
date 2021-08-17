let hardwareProfiles = { lib }:
let profiles = with profiles; lib.domainMerge {
  folder = ""; # not used in this usage
  folderPaths = [
    ./.
  ];
} // {
  }; in profiles;
in { __functor = self: hardwareProfiles; isModule = false; }
