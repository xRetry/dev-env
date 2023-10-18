{
    description = "Neovim flake with custom settings";

    inputs = {
        nixpkgs = {
            url = "github:NixOS/nixpkgs";
        };
    };

    outputs = { self, nixpkgs }:
    let
        system = "x86_64-linux";
        nvim_overlay = import ./nvim.nix;
        pkgs = import nixpkgs {
            inherit system;
            overlays = [ nvim_overlay ];
        };
    in rec {
        devShells.${system}.default = pkgs.mkShell {
            buildInputs = with pkgs; [
                neovim
            ];
        };
    };
}
