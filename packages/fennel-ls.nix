{
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
}
