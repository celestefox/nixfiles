{ lib, sources }:

with lib; let
  getSources = sources: removeAttrs sources [ "__functor" ];
  source2drv = value: if isDerivation value.outPath then value.outPath else value;
  sources2drvs = sources: mapAttrs (_: source2drv) (getSources sources);
in recurseIntoAttrs rec {
  local = sources2drvs sources;
    all = attrValues local; #++ attrValues hexchen;
    allStr = toString all;
  }
