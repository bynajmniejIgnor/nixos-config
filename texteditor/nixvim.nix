{
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;

    opts = {
      number = true;
      shiftwidth = 2;
    };
    
    keymaps = [
      {
	action = ":Telescope live_grep search_dirs=.<CR>";
	key = "<C-f>";
      }
      {
	action = "\"+y<CR>";
	key = "<C-c>";
      }
    ];

    plugins = {
      none-ls.settings.update_in_insert = true;
      lsp = {
	enable = true;
	servers = {
	  nil-ls.enable = true;
	  gopls.enable = true;
	};
      };
      telescope = {
	enable = true;
      };
      bufferline = {
	enable = true;
      };
    };
  };
}
