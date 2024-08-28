{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "ignor";
    homeDirectory = "/home/ignor"; 
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ignor/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      gaps = {
        inner = 7;
        outer = 7;
      };
      floating.titlebar = false;
      window = {
	titlebar = false;
	border = 5;
      };
      startup = [
	{
	  always = true; 
	  command = "pkill autotiling; autotiling";
	}
	{
	  always = true;
	  command = "xset -b";
	}
	{
	  always = true;
	  command = "pkill picom; picom";
	}
      ];
      bars = [
	{command = "pkill polybar; polybar top &";}
      ];
    };
    extraConfig = '' 
      bindsym Mod4+F2 exec firefox	
      bindsym --release Mod4+Shift+S exec scrot -s -f -o "/tmp/image.png" && xclip -selection clipboard -t image/png -i /tmp/image.png
      exec i3-msg workspace 1
    '';
  };

  programs.i3blocks = {
    enable = false;
  };

  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Macchiato";
    settings = {
      confirm_os_window_close = 0;
      font_size = 16;
      enable_audio_bell = "no";
      dynamic_background_opacity = "yes";
      background_opacity = "0.9";
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ra = "ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd \"$LASTDIR\"";
      v = "nvim";
    };
  };

  programs.ranger = {
    enable = true;
  };

  services.polybar = {
    enable = true;
    script = "polybar top &";
    config = {
      "bar/top" = {
	width = "100%";
	height = "3%";
	radius = 0;
	modules-center = "xworkspaces date";
      };

      "module/xworkspaces" = {
        type = "internal/xworkspaces";
        label-active = "%name%";
        label-active-padding = 1;

        label-occupied = "%name%";
        label-occupied-padding = 1;

        label-urgent = "%name%";
        label-urgent-padding = 1;

        label-empty = "%name%";
        label-empty-padding = 1;
      };

      "module/date" = {
	type = "internal/date";
	internal = 5;
	date = "%d.%m.%y";
	time = "%H:%M";
	label = "%time%  %date%";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
