{
  description = "nezia's portfolio website";
  outputs = {
    nixpkgs,
    sam-zola,
    ...
  }: let
    eachSystem = f: nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed f;
    themeName = (builtins.fromTOML (builtins.readFile "${sam-zola}/theme.toml")).name;
  in {
    devShells = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = [
          pkgs.zola
        ];
        shellHook = ''
          mkdir -p themes
          ln -sn "${sam-zola}" "themes/${themeName}";
        '';
      };
    });
    packages = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.stdenv.mkDerivation {
        name = "nezia.dev";
        src = ./.;
        nativeBuildInputs = [pkgs.zola];
        configurePhase = ''
          mkdir -p "themes/${themeName}"
          cp -r ${sam-zola}/* "themes/${themeName}"
        '';
        buildPhase = "zola build";
        installPhase = "cp -r public $out";
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
