{
    description = "Neovim flake with custom settings";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        flake-utils.url = "github:numtide/flake-utils";
        nvim-custom.url = "github:XRetry/nvim";
        tmux-custom.url = "github:XRetry/tmux";
    };

    outputs = { self, nixpkgs, flake-utils, nvim-custom, tmux-custom, ... }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (system:
    let
        pkgs = import nixpkgs {
            inherit system;
            overlays = [ 
                nvim-custom.overlays.default 
                tmux-custom.overlays.default
            ];
        }; 
    in rec {
        devShells = {
            default = pkgs.mkShell {
                buildInputs = with pkgs; [
                    tmux-configured
                    neovim-configured
                ];
            };
            cpp = pkgs.mkShell {
                buildInputs = with pkgs; [
                    tmux-configured
                    neovim-configured
                    gcc
                    clang-tools
                ];
            };
        };

        devShell = devShells.default;
    });
}
