{
  lib,
  fetchFromSourcehut,
  luajit,
}:
luajit.pkgs.buildLuaPackage {
  pname = "fennel-ls";
  version = "main";
  src = fetchFromSourcehut {
    owner = "~xerool";
    repo = "fennel-ls";
    rev = "824525573a6299c232a0b910a960bd59a563904f";
    hash = "sha256-qgHPXfIiIMw/hXkINgqv/OJb81TheiBBktuqrpJ+Z6s=";
  };
  propagatedBuildInputs = [luajit];
  patchPhase = ''
    patchShebangs --build fennel
  '';
  meta = with lib; {
    description = "A language server for Fennel";
    longDescription = ''
      A language server for fennel.
      Supports Go-to-definition, and a little bit of completion suggestions.
      Fennel-LS uses static analysis, and does not execute your code.

      For now, you can ask fennel-ls to **treat your file as a macro file** if the very first characters in the file exactly match `;; fennel-ls: macro-file`. Expect this to change at some point in the future when I come up with a better way to specify which files are meant to be macro files.
    '';
    homepage = "https://git.sr.ht/~xerool/fennel-ls";
    license = [licenses.mit];
    mainProgram = "fennel-ls";
  };
}
