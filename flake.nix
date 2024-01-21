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
        swtc = pkgs.writeShellApplication {
          name = "nvim-switch";
          runtimeInputs = with pkgs; [
            neovim
            neovim-qt
            stdenv.cc
            gnumake
            rustc
            cargo
          ];
          text = builtins.readFile ./nvim-switch.sh;
        };
      in
      {
        packages.default = pkgs.stdenvNoCC.mkDerivation {
          pname = "neovim-lazyvim";
          version = "0.1";
          dontUnpack = true;
          installPhase = ''
            mkdir -p $out/bin
            ln -s "${swtc}/bin/nvim-switch" $out/bin/nvim
            ln -s "${swtc}/bin/nvim-switch" $out/bin/nvim-qt
            ln -s "${pkgs.neovim-qt}/share" $out/share
          '';
        };
      });
}
