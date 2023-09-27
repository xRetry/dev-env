#!/bin/sh

setup_rust() {
	curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh -s -- -y
	echo "export PATH=$user/.cargo/bin:$PATH" >> $user/.bashrc
	su $user -c "export PATH=$user/.cargo/bin:$PATH"
	su $user -c "nvim --headless +'TSInstall rust' +'MasonInstall rust-analyzer' +'sleep 20' +qall"
}

setup_c() {
    su $user -c "nvim --headless +'TSInstall c cpp' +'MasonInstall clangd' +'sleep 40' +qall"
}

setup_python() {
    apt-get install -y python3 python3-pip
    pip install pyright
    su $user -c "nvim --headless +'TSInstall python' +'sleep 20' +qall"
}

setup_js() {
    apt-get install -y npm
    curl -fsSL https://bun.sh/install | bash
    su $user -c "nvim --headless +'TSInstall javascript' +'MasonInstall typescript-language-server' +'sleep 20' +qall"
}

setup_zig() {
    apt install xz-utils
    curl -L https://ziglang.org/download/0.11.0/zig-linux-x86_64-0.11.0.tar.xz > zig.tar.xz
    tar -xf zig.tar.xz
    mkdir $home/.local/share/zig
    mv zig-linux-x86_64-0.11.0/* $home/.local/share/zig/
    rm zig.tar.xz zig-linux-x85_64-0.11.0
    ln -s $home/.local/share/zig/zig /usr/local/bin/
    su $user -c "nvim --headless +'TSInstall zig' +'MasonInstall zls' +'sleep 20' +qall"
}


parse_lang() {
    case $1 in
        rust) setup_rust
            ;;
        c) setup_c
            ;;
        python) setup_python
            ;;
        js) setup_js
            ;;
        zig) setup_zig
            ;;
    esac
}

setup_tools() {
    home=$(awk -F: -v v="$user" '{if ($1==v) print $6}' /etc/passwd)

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
    chown -R $user $home
    su $user -c "nvim --headless +'Lazy sync' +'sleep 20' +qall"
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
	    parse_lang $OPTARG
            ;;
        t) 
	    user=$OPTARG
            setup_tools
            ;;
    esac
done

chown -R $user $home

exit 0

