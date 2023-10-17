{
    description = "Neovim flake with custom settings";

    inputs = {
        nixpkgs = {
            url = "github:NixOS/nixpkgs";
        };
    };

    outputs = { self, nixpkgs }:
    let
        nvim_overlay = import ./nvim.nix;
        pkgs = import nixpkgs {
            system = "x86_64-linux";
            overlays = [ nvim_overlay ];
        };
    in rec {
        devShell = pkgs.pkgs.mkShell {
            buildInputs = with pkgs; [
                neovim
            ];
        };
    };
}
