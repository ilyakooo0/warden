{
  description = "A very basic flake";

  inputs = {
    haskellNix.url = "github:input-output-hk/haskell.nix";
    nixpkgs.follows = "haskellNix/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, haskellNix, flake-compat }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ] (system:
      let
        overlays = [
          haskellNix.overlay
          (self: super: {
            gpr = self.grpc;
          })
        ];


        compiler = "ghc8107";
        pkgs = import nixpkgs { inherit system overlays; inherit (haskellNix) config; };

        project = { production }: pkgs.haskell-nix.cabalProject {
          compiler-nix-name = compiler;
          shell = {
            exactDeps = false;
            # crossPlatforms = p: [ p.ghcjs ];
            tools = {
              cabal = "latest";
              haskell-language-server = "latest";
              hlint = { };
              # haskell-language-server = {
              #   version = "latest";

              #   cabalProject = ''
              #     packages: .

              #     package haskell-language-server
              #       flags: -haddockcomments
              #     constraints:
              #       some == 1.0.3
              #   '';
              #   modules = [{
              #     reinstallableLibGhc = true;
              #   }];
              # };
            };
          };
          src = ./.;
          modules =
            pkgs.lib.optional production {
              ghcOptions = [
                "-O2"
                "-fexpose-all-unfoldings"
                "-fspecialise-aggressively"
              ];
              dontStrip = false;
              dontPatchELF = false;
              enableDeadCodeElimination = true;
              # packages.nobullshit-vpn.ghcOptions = [
              #   "-O2"
              #   "-fexpose-all-unfoldings"
              #   "-fspecialise-aggressively"
              #   "-Werror"
              # ];
            };
        };
        flake = (project { production = false; }).flake {
          crossPlatforms = p: [ p.ghcjs ];
        };
        flakeProd = (project { production = true; }).flake { };
        # presearch = flake.packages."presearch:exe:presearch";
      in
      flake // { packages.default = flake.packages."js-unknown-ghcjs:backend:exe:backend"; });
  # {
  #   devShell = flake.devShell;
  #   packages = {
  #     # default = presearch;
  #     # presearch-bin = flakeProd.packages."presearch:exe:presearch" + "/bin/presearch";
  #   };
  #   inherit flake;
  # });
}
