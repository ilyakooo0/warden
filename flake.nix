{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    bw = {
      url =
        # Afer this commit they started requiring path at the top level and I can't deal with this right now
        "github:bitwarden/clients?rev=ff143760d4f527f2349333ee4b3004eeda68fac5";
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

  outputs = inputs@{ self, nixpkgs, flake-utils, spago2nix, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        spagoPkgs = pkgs.callPackage ./spago-packages.nix { };
        easy-ps = pkgs.callPackage inputs.easy-ps { };
        nix-filter = import inputs.nix-filter;

        bw = pkgs.buildNpmPackage {
          pname = "bw";
          version = "latest";
          npmDepsHash = "sha256-jQvL7/SzXqVk03ncU6Mxq8lqFFy+lIrF2QheheXrQ0w=";
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
            ${pkgs.esbuild}/bin/esbuild backend.js --bundle --define:ENVIRONMENT_IS_WEB=true --define:ENVIRONMENT_IS_WORKER=false --define:ENVIRONMENT_IS_NODE=false --define:ENVIRONMENT_IS_SHELL=false --external:fs --external:path --loader:.wasm=base64 --outfile=$out 
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

        frontend = pkgs.callPackage ./frontend.nix { inherit nix-filter; };

        warden-src = pkgs.runCommand "warden-src" { } ''
          mkdir -p $out

          cp ${backend} $out/backend.js
          cp -r ${frontend}/Main.min.js $out/elm.js
          cp ${./index.html} $out/index.html
          cp ${./style.css} $out/style.css
          cp -r ${inputs.vanilla} $out/vanilla
        '';

        warden-click-src = pkgs.runCommand "warden-click-src" { } ''
          mkdir -p $out

          cp ${./warden.apparmor} $out/warden.apparmor
          cp ${./warden.desktop} $out/warden.desktop
          cp ${./manifest.json} $out/manifest.json
          cp ${./logo.png} $out/logo.png
          cp -r ${warden-src}/* $out/
        '';

        warden = pkgs.writeScript "warden" ''
          ${pkgs.electron}/bin/electron ${warden-src}/index.html
        '';

      in {
        packages = {
          inherit bw frontend warden-src backendBuildScript warden-click-src;
          vanilla = inputs.vanilla.outPath;
        };
        apps = {
          inherit (spago2nix.apps.${system}) spago2nix;
          warden = {
            type = "app";
            program = warden.outPath;
          };
        };

        devShells.default = import ./shell.nix { inherit pkgs; };
      });
}
