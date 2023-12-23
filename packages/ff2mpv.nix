{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  mpv,
  makeBinaryWrapper,
}:
stdenv.mkDerivation rec {
  pname = "ff2mpv";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "woodruffw";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sxUp/JlmnYW2sPDpIO2/q40cVJBVDveJvbQMT70yjP4=";
  };

  nativeBuildInputs = [makeBinaryWrapper];

  buildInputs = [python3 mpv];

  postPatch = ''
    patchShebangs .
    substituteInPlace ff2mpv.json \
      --replace '/home/william/scripts/ff2mpv' "$out/bin/ff2mpv.py"
  '';

  /*
  An explanation of the changes here (makeBinaryWrapper also added above):
  mpv started to crash from ff2mpv, which i found out seemed to maybe be
  because of library versions, and I could see that it was being launched
  with a LD_LIBRARY_PATH, apparently from firefox. ff2mpv itself is fine and
  does not crash, but it is the place where the variable should probably be
  dropped, and this is a nix-specific fix needed here.
  */
  installPhase = ''
    mkdir -p $out/bin $out/lib/mozilla/native-messaging-hosts
    cp ff2mpv.py $out/bin
    cp ff2mpv.json $out/lib/mozilla/native-messaging-hosts
    wrapProgram $out/bin/ff2mpv.py --unset LD_LIBRARY_PATH
  '';

  meta = {
    description = "Native Messaging Host for ff2mpv firefox addon.";
    homepage = "https://github.com/woodruffw/ff2mpv";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [Enzime];
  };
}
