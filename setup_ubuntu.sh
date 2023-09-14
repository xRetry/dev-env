#!/bin/sh

setup_rust() {
	curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y
	echo "export PATH=$user/.cargo/bin:$PATH" >> $user/.bashrc
	export PATH=$user/.cargo/bin:$PATH
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

parse_lang() {
    case $1 in
        rust) setup_rust
            ;;
        c) setup_c
            ;;
        python) setup_python
            ;;
    esac
}

setup_tools() {
    home=$(awk -F: -v v="$1" '{if ($1==v) print $6}' /etc/passwd)

    # Bash
    echo "set -o vi" >> $home/.bashrc
    echo "export TERM=screen-256color-bce" >> $home/.bashrc

    # Tmux
    apt-get install -y tmux
    # Tmux - Config
    mkdir -p $home/.config/tmux
    git clone https://github.com/xRetry/tmux.git $home/.config/tmux

    # Neovim
    curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
    tar xzvf nvim-linux64.tar.gz
    mkdir -p $home/.local/share/nvim-linux64
    mv nvim-linux64 $home/.local/share/
    ln -s $home/.local/share/nvim-linux64/bin/nvim /usr/local/bin/nvim
    rm nvim-linux64.tar.gz
    # Neovim - Config
    mkdir -p $home/.config/nvim
    git clone https://github.com/xRetry/nvim.git $home/.config/nvim
    nvim --headless +'Lazy sync' +'sleep 20' +qall
}

apt-get update && apt-get install -y \
    curl \
    git \
    g++ \
    unzip

user=$(id -u -n)

while getopts "t:l:" opt 
do
    case $opt in
        l) 
	    parse_lang $OPTARG $user
            ;;
        t) 
	    user=$OPTARG
            setup_tools $user
            ;;
    esac
done

exit 0

