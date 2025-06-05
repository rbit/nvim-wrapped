{
  description = "Neovim with lazyvim dependencies";

  inputs = {
    nixpkgs-stable.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs-stable
    , nixpkgs-unstable
    , flake-utils
    , ...
    }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs-stable.legacyPackages.${system};
        nvpkgs = nixpkgs-unstable.legacyPackages.${system};
      in
      {
        packages.default = pkgs.buildFHSEnv {
          name = "nvim";
          targetPkgs = pkgs: (with pkgs; [
            wl-clipboard-rs
            stdenv.cc
            gnumake
            nodejs
            rustc
            cargo
          ]);
          runScript = "${nvpkgs.neovim}/bin/nvim";
          extraBwrapArgs = [
            "--bind /etc/nixos /etc/nixos"
            "--bind /etc/vroot /etc/vroot"
          ];
        };
      });
}
