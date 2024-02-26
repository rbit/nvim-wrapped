{
  description = "Neovim with lazyvim dependencies";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.buildFHSEnv {
          name = "nvim";
          targetPkgs = pkgs: (with pkgs; [
            stdenv.cc
            gnumake
            rustc
            cargo
          ]);
          runScript = "${pkgs.neovim}/bin/nvim";
          extraBwrapArgs = [
            "--bind /etc/nixos /etc/nixos"
          ];
        };
      });
}
