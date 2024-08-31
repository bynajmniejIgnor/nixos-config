{pkgs, ...}: {
  services = {
    libinput.enable = true;
    displayManager.defaultSession = "none+i3";
    xserver = {
      enable = true;
      xkb.layout = "pl";
      windowManager.i3 = {
	enable = true;
      };
      desktopManager.wallpaper.mode = "fill";
    };
    picom = {
      enable = true;
    };
  };
}
