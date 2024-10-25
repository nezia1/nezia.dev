{
  description = "nezia's portfolio website";

  outputs = {
    nixpkgs,
    systems,
    ...
  }: let
    eachSystem = f: nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f nixpkgs.legacyPackages.${system});
  in {
    devShells = eachSystem (pkgs: {
      default = pkgs.mkShell {
        packages = [pkgs.go pkgs.hugo];
      };
    });
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/07518c851b0f12351d7709274bbbd4ecc1f089c7";
  };
}
