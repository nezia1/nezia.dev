{
  description = "nezia's portfolio website";
  outputs = {nixpkgs, ...}: let
    eachSystem = f: nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed f;
  in {
    devShells = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = [
          pkgs.go_1_22
          pkgs.hugo
          pkgs.nodejs
        ];
      };
    });
    packages = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.stdenv.mkDerivation (finalAttrs: {
        pname = "portfolio";
        name = finalAttrs.pname;
        src = ./.;
        nativeBuildInputs = [
          pkgs.go
          pkgs.hugo
          pkgs.nodejs
        ];
        buildPhase = let
          hugoVendor = pkgs.stdenv.mkDerivation {
            name = "${finalAttrs.pname}-hugoVendor";
            inherit (finalAttrs) src nativeBuildInputs;
            buildPhase = ''
              hugo mod vendor
            '';
            installPhase = ''
              cp -r _vendor $out
            '';
            outputHashMode = "recursive";
            outputHash = "sha256-HTIbu1M3w8escODTPy+c0uNEZNvBbiXAraCsqtyvBiA=";
          };

          npmDeps = pkgs.buildNpmPackage {
            name = "${finalAttrs.pname}-npmDeps";
            inherit (finalAttrs) src nativeBuildInputs;

            npmDepsHash = "sha256-qm12Sv7y0jggO7ygHqEmqLzBzmM1UIlDgo/y31hjBvA=";

            installPhase = ''
              cp -r node_modules $out/
            '';
            dontBuild = true;
          };
        in ''
          cp -r ${hugoVendor} _vendor
          cp -r ${npmDeps} node_modules
          hugo --minify -d $out
        '';
        dontInstall = true;
        dontFixup = true;
      });
    });
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/07518c851b0f12351d7709274bbbd4ecc1f089c7";
  };
}
