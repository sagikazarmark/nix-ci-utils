# Nix CI utilities

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/sagikazarmark/nix-ci-utils/ci.yaml?style=flat-square)
[![built with nix](https://img.shields.io/badge/builtwith-nix-7d81f7?style=flat-square)](https://builtwithnix.org)

**Nix CI utilities**

**⚠️ This tool is still under heavy development! Things may change. ⚠️**

## Usage

```nix
{
  description = "My Go project";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    ci.url = "github:sagikazarmark/nix-ci-utils";
    ci.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, ci, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        devShells = {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              go_1_19
              gnumake
              xcaddy
              go-task
              golangci-lint
            ];
          };
        }
        //
        (ci.lib.genShellsFromList [ "1_19" "1_20" ] (goVersion:
          devShells.default.overrideAttrs (final: prev: {
            buildInputs = [ pkgs."go_${goVersion}" ] ++ prev.buildInputs;
          })
        ));
      }
    );
}
```

Alternatively, you can generate a matrix from an attribute set:

```nix
{
# ...
  outputs = {
    # ...
        //
        (ci.lib.genShellsFromMatrixAttrs { goVersion = [ "1_19" "1_20" ]; } (e:
          devShells.default.overrideAttrs (final: prev: {
            buildInputs = [ pkgs."go_${e.goVersion}" ] ++ prev.buildInputs;
          })
        ));
  };
}
```

## License

The project is licensed under the [MIT License](LICENSE).
