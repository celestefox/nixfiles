{ stdenv, lib, fetchzip, autoPatchelfHook, makeWrapper, libGL, libX11, libdrm, libxcrypt-legacy, zlib }: stdenv.mkDerivation rec {
  # The linux binary package of randovania, packaged in Nix. This expression isn't perfect, but it seems to work.
  # I don't think it makes sense to try to put this in nixpkgs or anything, given a source build *should* be possible?
  # But I wanted to avoid that if I could, and if I don't mind using the bundled deps, it looks like...
  pname = "randovania-bin";
  version = "5.7.0";

  src = fetchzip {
    url = "https://github.com/randovania/randovania/releases/download/v${version}/randovania-${version}-linux.tar.gz";
    sha256 = "0gz9w9z9a5ccbj95d2vg6ggfn0kvbkj7nw0194fg1x6y766ja2g5";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [
    libGL
    libX11
    libdrm
    libxcrypt-legacy
    zlib
  ];

  libPath = lib.makeLibraryPath buildInputs;

  # (unsure if drm is needed here), qtwebengine, qtvirtualkeyboard; if i want to try to add them... but I suspect they aren't actually needed in practice?
  autoPatchelfIgnoreMissingDeps = [ "libdrm.so.2" "libQt6Pdf.so.6" "libQt6VirtualKeyboard.so.6" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/randovania
    cp -r . $out/randovania

    chmod +x $out/randovania/randovania
    patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
      $out/randovania/randovania

    wrapProgram $out/randovania/randovania --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib:$libPath:$out/randovania

    mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps
    substitute ./xdg_assets/io.github.randovania.Randovania.desktop $out/share/applications/io.github.randovania.Randovania.desktop \
      --replace "Exec=randovania" "Exec=\"$out/randovania/randovania\""
    cp xdg_assets/io.github.randovania.Randovania.png $out/share/icons/hicolor/256x256/apps/io.github.randovania.Randovania.png

    mkdir $out/bin
    ln -s $out/randovania/randovania $out/bin/
    runHook postInstall
  '';

  meta = {
    description = "A randomizer platform for a multitude of games";
    homepage = "https://github.com/randovania/randovania";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
