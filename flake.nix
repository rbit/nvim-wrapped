{
  description = "Neovim with lazyvim dependencies";

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
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
          ];
        };
      });
}
