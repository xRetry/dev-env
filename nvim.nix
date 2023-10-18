final: prev: {
    neovim = prev.neovim.override {
        configure = {
            customRC = ''
                set number 
            '';
        };
    };
}
