{
    description = "Neovim flake with custom settings";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs";
        nvim-config.url = "github:XRetry/nvim";
        tmux-config.url = "github:XRetry/tmux";
    };

    outputs = { self, nixpkgs, nvim-config, tmux-config, ... }:
    let
        system = "x86_64-linux";
        pkgs = import nixpkgs {
            inherit system;
            overlays = [ nvim-config tmux-config ];
        };
    in rec {
        devShells.${system}.default = pkgs.mkShell {
            buildInputs = with pkgs; [
                tmux
                neovim
            ];
        };
    };
}
