{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    bw = {
      url = "github:bitwarden/clients";
      flake = false;
    };
    spago2nix.url = "github:justinwoo/spago2nix";
    easy-ps = {
      url = "github:justinwoo/easy-purescript-nix";
      flake = false;
    };
    vanilla = {
      url = "github:ilyakooo0/vanilla-compiled";
      flake = false;
    };
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, spago2nix, vanilla, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        spagoPkgs = pkgs.callPackage ./spago-packages.nix { };
        easy-ps = pkgs.callPackage inputs.easy-ps { };
        nix-filter = import inputs.nix-filter;

      in {
        packages = rec {
          bw = pkgs.buildNpmPackage {
            pname = "bw";
            version = "latest";
            npmDepsHash = "sha256-i6HVuyAODrjxGrWfhC6Pa6mwjALshKgsHQZKO7nq5Mo=";
            makeCacheWritable = true;
            src = inputs.bw;
            nativeBuildInputs = [ pkgs.python3 ];
            buildPhase = ''
              (cd libs/common/ && rm -r spec && find . -name "*.spec.ts" -exec rm {} \; && npm exec -c "tsc -m es2020 -t es2018") '';
            installPhase = ''
              mkdir -p $out
              cp -r libs/shared/dist/* $out
              cp -r node_modules $out/node_modules
              cp package.json $out/package.json
            '';
            ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
          };

          backendBuildScript = pkgs.writeScript "build-backend.sh" ''
            workdir=$(mktemp -d)
            (
              cd $workdir
              cp -r $1 ./backend
              cp -r ${bw} ./bw
              cp ${./backend-main.js} backend.js
              ${pkgs.esbuild}/bin/esbuild backend.js  --bundle --external:fs --external:path --loader:.wasm=base64 --outfile=$out 
            )

          '';
          backend-js = pkgs.stdenv.mkDerivation {
            name = "backend-js";
            buildInputs =
              [ spagoPkgs.installSpagoStyle spagoPkgs.buildSpagoStyle ];
            nativeBuildInputs = [ easy-ps.purs-0_15_7 easy-ps.spago ];
            src = nix-filter {
              root = ./.;
              include = [
                ./spago.dhall
                ./packages.dhall
                (nix-filter.inDirectory ./backend)
              ];
            };
            unpackPhase = ''
              cp $src/spago.dhall .
              cp $src/packages.dhall .
              cp -r $src/backend .
              install-spago-style
            '';
            buildPhase = ''
              build-spago-style "./backend/**/*.purs"
            '';
            installPhase = ''
              mkdir $out
              cp -r output/* $out/
            '';
          };

          backend =
            pkgs.runCommand "backend.js" { buildInputs = [ pkgs.esbuild ]; } ''
              ${backendBuildScript} ${backend-js}
            '';

          frontend = pkgs.callPackage ./frontend.nix { };

          warden-src = pkgs.runCommand "warden-src" { } ''
            mkdir -p $out

            cp ${backend} $out/backend.js
            cp -r ${frontend}/Main.min.js $out/elm.js
            cp ${./index.html} $out/index.html
            cp ${./style.css} $out/style.css
            cp -r ${vanilla} $out/vanilla
          '';

          warden = pkgs.runCommand "warden" { } ''
            ${pkgs.nodePackages_latest.parcel}/bin/parcel build ${warden-src}/Main/index.js --dist-dir=$out
          '';
        };
        apps = { inherit (spago2nix.apps.${system}) spago2nix; };

        devShells.default = import ./shell.nix { inherit pkgs; };
      });
}
