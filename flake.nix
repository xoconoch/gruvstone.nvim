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

          src = pkgs.fetchFromGitHub {
            owner = "xoconoch";
            repo = "gruvstone.nvim";
            rev = "055eed60ccad6b91581b76c228ca4dd37f3ba637";
            sha256 = "sha256-Ff+Wv3HkyI9C/C0kadxkU5Jfh1XvX11nI7p0ZeN9Vas=";
          };

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
