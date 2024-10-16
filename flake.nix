{
  description = "Neovim with lazyvim dependencies";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nvimpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nvimpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nvpkgs = nvimpkgs.legacyPackages.${system};
      in
      {
        packages.default = pkgs.buildFHSEnv {
          name = "nvim";
          targetPkgs = pkgs: (with pkgs; [
            stdenv.cc
            gnumake
            nodejs
            rustc
            cargo
          ]);
          runScript = "${nvpkgs.neovim}/bin/nvim";
          extraBwrapArgs = [
            "--bind /etc/nixos /etc/nixos"
          ];
        };
      });
}
