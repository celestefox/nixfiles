{
  lib,
  fetchurl,
  appimageTools,
  unzip,
  makeDesktopItem,
}: let
  icon = fetchurl {
    url = "https://github.com/HarbourMasters/Shipwright/raw/9b947615bcf39e8546699edeafe77ebb39426caa/soh/macosx/sohIcon.png";
    hash = "sha256-M//KmohmKXALzpLzNNPUYNpI9BshlIVMAoDeo/ZFGFA=";
  };
  desktopItem = makeDesktopItem {
    name = "soh";
    desktopName = "Ship of Harkinian";
    exec = "soh";
    inherit icon;
    categories = ["Game"];
  };
in
  appimageTools.wrapType2 {
    name = "soh";
    src = fetchurl {
      # all of this is because the soh appimage is distributed as a zip of it and a readme.txt,
      # while appimageTools wants just the image, so even fetchzip w/ `stripRoot = false;` isn't enough
      # the other approach would be an intermediary deviation that only outputs the image from a simple fetcher call
      name = "soh.appimage";
      url = "https://github.com/HarbourMasters/Shipwright/releases/download/8.0.4/SoH-MacReady-Echo-Linux-Performance.zip";
      hash = "sha256-H3OxjiqixhTu2CMg4VTtHaEn67P+Qb2gqXYR85BBjBA=";
      downloadToTemp = true;
      nativeBuildInputs = [unzip];
      # adapted from nixpkgs/pkgs/build-support/fetchzip/default.nix
      # hardcode zip, only move soh.appimage specifically, 644 to stop hash mode error
      postFetch = ''
        unpackDir="$TMPDIR/unpack"
        mkdir "$unpackDir"
        cd "$unpackDir"

        renamed="$TMPDIR/download.zip"
        mv "$downloadedFile" "$renamed"
        unpackFile "$renamed"
        chmod -R +w "$unpackDir"

        mv "$unpackDir/soh.appimage" "$out"
        chmod 644 "$out"
      '';
    };
    extraInstallCommands = ''
      mkdir -p $out/share
      cp -v -r ${desktopItem}/share/applications $out/share
    '';
    meta = {
      homepage = "https://www.shipofharkinian.com/";
      downloadPage = "https://github.com/HarbourMasters/Shipwright/releases";
      # soh's license is unclear, or at least I can't find it
      # the repo is public, and you separately need the rom to actually play, instead
      # ... I'm going to be safe for now, at least until I feel up to trying to ask in discord or smth
      license = lib.licenses.unfree;
      platforms = lib.platforms.linux;
      mainProgram = "soh";
    };
  }
