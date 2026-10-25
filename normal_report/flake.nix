{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    typst-packages = {
      url = "github:typst/packages";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, typix, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem = { system, pkgs, ... }: let
        typixLib = inputs.typix.lib.${system};

        src = typixLib.cleanTypstSource ./.;

        typstPackagesSrc = pkgs.symlinkJoin {
          name = "typst-packages-src";
          paths = [
            "${inputs.typst-packages}/packages"
          ];
        };

        typstPackagesCache = pkgs.stdenv.mkDerivation {
          name = "typst-packages-cache";
          src = typstPackagesSrc;
          dontBuild = true;
          installPhase = ''
            mkdir -p "$out"
            cp -LR --reflink=auto --no-preserve=mode -t "$out" "$src"/*
          '';
        };

        commonArgs = {
          typstSource = "main.typ";
          fontPaths = [
            "${pkgs.noto-fonts-cjk-serif-static}/share/fonts/opentype"
            "${pkgs.noto-fonts-cjk-sans-static}/share/fonts/opentype"
          ];
          virtualPaths = [];
          typstOpts = {
            package-path = typstPackagesCache;
          };
        };

        build-drv = typixLib.buildTypstProject (commonArgs // { inherit src; });

        build-script = typixLib.buildTypstProjectLocal (commonArgs // { inherit src; });

        watch-script = typixLib.watchTypstProject commonArgs;

      in {
        packages.default = build-drv;

        checks = {
          inherit build-drv build-script watch-script;
        };

        apps = {
          default = watch-script;
          build.program = build-script;
          watch.program = watch-script;
        };

        devShells.default = typixLib.devShell {
          inherit (commonArgs) fontPaths virtualPaths;
          packages = with pkgs; [
            watch-script
            tinymist
            gnuplot_qt
            poppler-utils
          ];
        };
      };
    };
}
