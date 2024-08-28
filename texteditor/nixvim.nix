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
	action = ":Telescope find_files hidden=true<CR>";
	key = "<C-f>";
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
    };
  };
}
