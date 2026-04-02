{
  description = "Flake exporting a Vim plugin";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        gruvstone = pkgs.vimUtils.buildVimPlugin {
          pname = "gruvstone";
          version = "0.1.0";

          src = ./.;

          meta = with pkgs.lib; {
            description = "Alabaster for gruvbox";
            homepage = "https://github.com/xoconoch/gruvstone";
            license = licenses.mit;
          };
        };

      in
      {
        packages = {
          inherit gruvstone;
          default = gruvstone;
        };
      }
    );
}
