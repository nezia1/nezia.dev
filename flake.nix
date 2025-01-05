{
  description = "nezia's portfolio website";
  outputs = {
    nixpkgs,
    sam-zola,
    resume,
    ...
  }: let
    eachSystem = f: nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed f;
    themeName = (builtins.fromTOML (builtins.readFile "${sam-zola}/theme.toml")).name;
  in {
    devShells = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = [pkgs.zola];
        shellHook = ''
          mkdir -p themes
          ln -sn "${sam-zola}" "themes/${themeName}"
          ln -sn $(find ${resume.packages.${pkgs.system}.default} -name "*.pdf") static/resume.pdf
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
          cp $(find ${resume.packages.${pkgs.system}.default} -name "*.pdf") static/resume.pdf
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
    resume = {
      url = "github:nezia1/resume";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
