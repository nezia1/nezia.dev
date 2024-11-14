{
  description = "nezia's portfolio website";
  outputs = {
    nixpkgs,
    sam-zola,
    ...
  }: let
    eachSystem = f: nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed f;
  in {
    devShells = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = [
          pkgs.go_1_22
          pkgs.hugo
          pkgs.zola
          pkgs.nodejs
        ];
      };
    });
    packages = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.stdenv.mkDerivation {
        name = "nezia.dev";
        src = ./.;
        nativeBuildInputs = [
          pkgs.zola
        ];
        configurePhase = ''
          mkdir -p themes/sam
          cp --no-preserve=mode -r ${sam-zola}/* themes/sam
        '';
        buildPhase = "zola build";
        installPhase = "cp -r public $out";
        dontFixup = true;
      };
    });
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    sam-zola = {
      url = "github:janbaudisch/zola-sam";
      flake = false;
    };
  };
}
