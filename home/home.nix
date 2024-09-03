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
      menu = "rofi -show-icons -display-drun \" >\" -show drun";
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
      font_family = "JetBrainsMono Nerd Font Mono";
      bold_font = "JetBrainsMono Nerd Font Mono Extra Bold";
      bold_italic_font = "JetBrainsMono Nerd Font Mono Extra Bold Italic";
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
      nrs = "sudo nixos-rebuild switch --flake .";
      ns = "nix-shell -p";
    };
  };

  programs.ranger = {
    enable = true;
  };

  services.polybar = {
    enable = true;
    script = "polybar top &";
    config = {
      "colors" = {
	background = "#282A2E";
	background-alt = "#88373B41";
	foreground = "#C5C8C6";
	primary = "#8AADF4";
	secondary = "#8ABEB7";
	alert = "#88ED8796";
	disabled = "#707880";
	success = "#88A6DA95";
      };
      "bar/top" = {
	font-0 = "JetBrainsMono:size=16;2";
	width = "100%";
	height = "30";

	background = "#00000000";
	foreground = "$\{colors.foreground\}";
	line-size = "3pt";
	border-size = "4pt";
    
	border-color = "#00000000";
	padding-left = 2;
	padding-right = 2;
	separator = "|";
	separator-foreground = "$\{colors.disabled\}";
	separator-background = "$\{colors.background-alt\}";
	modules-left = "xworkspaces";
	modules-center = "blank";
	modules-right = "xkeyboard battery1 battery0 date";
	cursor-click = "pointer";
	cursor-scroll = "ns-resize";
	enable-ipc = true;
      };

      "module/xworkspaces" = {
	type = "internal/xworkspaces";
	background = "$\{colors.background\}";
	foreground = "$\{colors.foreground\}";

	label-active = "%name%";
	label-active-background = "$\{colors.background-alt\}";
	label-active-underline= "$\{colors.primary\}";
	label-active-padding = 2;

	label-occupied = "%name%";
	label-occupied-background = "$\{colors.background-alt\}";
	label-occupied-padding = 2;

	label-urgent = "%name%";
	label-urgent-background = "$\{colors.alert\}";
	label-urgent-padding = 2;

	label-empty = "%name%";
	label-empty-background = "$\{colors.background-alt\}";
	label-empty-foreground = "$\{colors.disabled\}";
	label-empty-padding = 2;
      };

      "module/date" = {
	type = "internal/date";
	internal = 5;
	date = "%d.%m.%y";
	time = "%H:%M";
	label = "%time%  %date%";
	label-padding = 2;
	format-background = "$\{colors.background-alt\}";
      };

      "module/battery0" = {
	type = "internal/battery";
	full-at = 99;
	low-at = 2;
	battery = "BAT0";
	poll-interval = 5;
	

	format-charging-background = "$\{colors.background-alt\}";
	format-discharging-background = "$\{colors.background-alt\}";
	format-full-background = "$\{colors.success\}";
	format-low-background = "$\{colors.alert\}";
	label-charging-padding = 1;
	label-discharging-padding = 1;
	label-full-padding = 1;
	label-low-padding = 1;
      };

      "module/battery1" = {
	type = "internal/battery";
	full-at = 99;
	low-at = 5;
	battery = "BAT1";
	poll-interval = 5;

	format-charging-background = "$\{colors.background-alt\}";
	format-discharging-background = "$\{colors.background-alt\}";
	format-full-background = "$\{colors.success\}";
	format-low-background = "$\{colors.alert\}";
	label-charging-padding = 1;
	label-discharging-padding = 1;
	label-full-padding = 1;
	label-low-padding = 1;
      };

      "module/xkeyboard" = {
	type = "internal/xkeyboard";
	blacklist-0 = "num lock";
	blacklist-1 = "scroll lock";
	label-layout = "";
	label-indicator-on-capslock-padding = 1;
	label-indicator-off-capslock-padding = 1;
	label-indicator-on-capslock = "Caps on";
	label-indicator-off-capslock = "Caps off";
	label-indicator-on-capslock-background = "$\{colors.alert\}";
	label-indicator-off-capslock-background = "$\{colors.background-alt\}";
      };
    };
  };
  
  # inspired by https://gitlab.com/nesstero/catppuccin/-/blob/master/rofi/config.rasi
  programs.rofi = {
    enable = true;
    theme = 
    let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
	font = "JetBrainsMono Nerd Font 16";
	foreground = mkLiteral "#DADAE8";
	background = mkLiteral "#1E1E2E";
	active-background = mkLiteral "#A4B9EF";
	urgent-background  = mkLiteral "#E38C8F";
	urgent-foreground = mkLiteral "@foreground";
	selected-background = mkLiteral "@active-background";
	selected-urgent-background = mkLiteral "@urgent-background";
	selected-active-background = mkLiteral "@active-background";
	separatorcolor = mkLiteral "@active-background";
	bordercolor = mkLiteral "@active-background";
      };

      "window" = {
	background-color = mkLiteral "@background";
	border = 3;
	border-radius = 10;
	border-color = mkLiteral "@bordercolor";
	padding = 5;
	width = mkLiteral "40%";
      };

      "mainbox" = {
	border = 0;
	padding = 0;
	background-color = mkLiteral "inherit";
      };

      "message" = {
	border = mkLiteral "0px dash 0px 0px";
	border-color = mkLiteral "@separatorcolor";
	padding = mkLiteral "1px";
      };

      "textbox" = {
	text-color = mkLiteral "@foreground";
      };

      "listview" = {
	fixed-height = 0;
	background-color = mkLiteral "@background";
	border = mkLiteral "2px dash 0px 0px";
	border-color = mkLiteral "@bordercolor";
	spacing = mkLiteral "2px";
	scrollbar = false;
	padding = mkLiteral "2px 0px 0px";
	lines = 7;
      };

      "element" = {
	border = 0;
	padding = mkLiteral "1px 7px";
      };

      "element-text" = {
	background-color = mkLiteral "inherit";
	text-color = mkLiteral "inherit";
      };

      "element-icon" = {
	background-color = mkLiteral "inherit";
	margin = mkLiteral "0px 10px 0px 0px";
	size = mkLiteral "20px";
      };

      "element.normal.normal" = {
	background-color = mkLiteral "@background";
	text-color = mkLiteral "@foreground";
      };

      "element.normal.urgent" = {
	background-color = mkLiteral "@urgent-background";
	text-color = mkLiteral "@urgent-foreground";
      };

      "element.normal.active" = {
	background-color = mkLiteral "@active-background";
	text-color = mkLiteral "@foreground";
      };

      "element.selected.normal" = {
	background-color = mkLiteral "@selected-background";
	border-radius = 10;
	text-color = mkLiteral "@background";
      };

      "element.selected.urgent" = {
	background-color = mkLiteral "@selected-urgent-background";
	text-color = mkLiteral "@background";
      };

      "element.selected.active" = {
	background-color = mkLiteral "@selected-active-background";
	text-color = mkLiteral "@background";
      };

      "element.alternate.normal" = {
	background-color = mkLiteral "@background";
	text-color = mkLiteral "@foreground";
      };

      "element.alternate.urgent" = {
	background-color = mkLiteral "@urgent-background";
	text-color = mkLiteral "@foreground";
      };

      "element.alternate.active" = {
	background-color = mkLiteral "@active-background";
	text-color = mkLiteral "@foreground";
      };

      "button.selected" = {
	background-color = mkLiteral "@selected-background";
	text-color = mkLiteral "@foreground";
      };

      "inputbar" = {
	spacing = 0;
	text-color = mkLiteral "@foreground";
	background-color = mkLiteral "@background";
	padding = mkLiteral "1px";
	children = mkLiteral "[ prompt,textbox-prompt-colon,entry,case-indicator ]";
      };

      "case-indicator" = {
	spacing = 0;
	background-color = mkLiteral "inherit";
	text-color = mkLiteral "@foreground";
      };

      "entry" = {
	spacing = 0;
	background-color = mkLiteral "inherit";
	text-color = mkLiteral "@foreground";
      };

      "prompt" = {
	spacing = 0;
	background-color = mkLiteral "inherit";
	text-color = mkLiteral "@foreground";
      };

      "textbox-prompt-colon" = {
	expand = false;
	str = "";
	margin = mkLiteral "0px 0.3em 0em 0em";
	text-color = mkLiteral "@foreground";
	background-color = mkLiteral "inherit";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
