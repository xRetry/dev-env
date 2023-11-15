{
    description = "Neovim flake with custom settings";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        flake-utils.url = "github:numtide/flake-utils";
        nvim-config.url = "github:XRetry/nvim";
        tmux-config.url = "github:XRetry/tmux";
    };

    outputs = { self, nixpkgs, flake-utils, nvim-config, tmux-config, ... }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (system:
    let
        pkgs = import nixpkgs {
            inherit system;
            overlays = [ 
                nvim-config.overlays.default 
                tmux-config.overlays.default 
            ];
        }; 
    in rec {
        devShells = {
            default = pkgs.mkShell {
                buildInputs = with pkgs; [
                    tmux
                    neovim
                ];
            };
            cpp = pkgs.mkShell {
                buildInputs = with pkgs; [
                    tmux
                    neovim
                    gcc
                    clang-tools
                ];
            };
        };

        devShell = devShells.default;
    });
}
