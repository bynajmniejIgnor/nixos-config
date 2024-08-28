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
    };
    picom = {
      enable = true;
    };
  };
}
