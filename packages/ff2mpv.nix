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