{ nixpkgs }:
let
  inherit (nixpkgs.lib) runTests;
  lib = import ./lib.nix { inherit (nixpkgs) lib; };
in
runTests {
  testGenShellsFromMatrixAttrs = {
    expr = (lib.genShellsFromMatrixAttrs { goVersion = [ "1_19" "1_20" ]; } (attrs: attrs.goVersion)) == { ci_1_19 = "1_19"; ci_1_20 = "1_20"; };
    expected = true;
  };

  testGenShellsFromList = {
    expr = (lib.genShellsFromList [ "1_19" "1_20" ] (v: v)) == { ci_1_19 = "1_19"; ci_1_20 = "1_20"; };
    expected = true;
  };
}
