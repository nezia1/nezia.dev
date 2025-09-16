{
  description = "nezia's portfolio website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    tabi = {
      url = "github:welpo/tabi";
      flake = false;
    };
    resume = {
      url = "github:nezia1/resume";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {
    self,
    nixpkgs,
    tabi,
    resume,
    treefmt-nix,
  }: let
    eachSystem = f: nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed f;
    themeName = (builtins.fromTOML (builtins.readFile "${tabi}/theme.toml")).name;
  in {
    devShells = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = [pkgs.zola];
        shellHook = ''
          mkdir -p themes
          ln -sn "${tabi}" "themes/${themeName}"
          cp $(find ${resume.packages.${pkgs.system}.default} -name "*.pdf") static/resume.pdf
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
          cp -r ${tabi}/* "themes/${themeName}"
          cp $(find ${resume.packages.${pkgs.system}.default} -name "*.pdf") static/resume.pdf
        '';
        buildPhase = "zola build";
        installPhase = "cp -r public $out";
      };
    });

    formatter = eachSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      treefmtEval = eachSystem (_: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
      treefmtEval.${system}.config.build.wrapper);
  };
}
