{
  description = "Nix CI utils";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    {
      lib = import ./lib.nix { inherit (nixpkgs) lib; };
      tests =
        let
          results = import ./test.nix { inherit nixpkgs; };
        in
        if results == [ ]
        then "all tests passed"
        else throw (builtins.toJSON results);
    };
}
