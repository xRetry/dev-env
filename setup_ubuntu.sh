#!/bin/sh

setup_rust() {
	curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y
	echo "export PATH=~/.cargo/bin:$PATH" >> ~/.bashrc
	export PATH=~/.cargo/bin:$PATH
	nvim --headless +'TSInstall rust' +'MasonInstall rust-analyzer' +'sleep 20' +qall
}

setup_c() {
    nvim --headless +'TSInstall c cpp' +'MasonInstall clangd' +'sleep 40' +qall
}

setup_python() {
    apt-get install -y python3 python3-pip
    pip install pyright
    nvim --headless +'TSInstall python' +'sleep 20' +qall
}

apt-get update && apt-get install -y \
    curl \
    git \
    g++ \
    unzip
 
# Bash
echo "set -o vi" >> ~/.bashrc
echo "export TERM=screen-256color-bce" >> ~/.bashrc

# Tmux
apt-get install -y tmux
# Tmux - Config
mkdir -p ~/.config/tmux
git clone https://github.com/xRetry/nvim.git ~/.config/nvim

# Neovim
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar xzvf nvim-linux64.tar.gz
mkdir -p ~/.local/share/nvim-linux64
mv nvim-linux64 ~/.local/share/
ln -s ~/.local/share/nvim-linux64/bin/nvim /usr/bin/nvim
rm nvim-linux64.tar.gz
# Neovim - Config
mkdir -p ~/.config/nvim
git clone https://github.com/xRetry/nvim.git ~/.config/nvim
nvim --headless +'Lazy sync' +'sleep 20' +qall


while test $# -gt 0
do
    case "$1" in
        rust) setup_rust
            ;;
        c) setup_c
            ;;
        python) setup_python
            ;;
    esac
    shift
done

exit 0

