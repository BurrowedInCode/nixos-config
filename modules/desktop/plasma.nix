{ ... }:

{
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Do not start a GUI crash reporter between graphical sessions.
  systemd.user.services."drkonqi-coredump-launcher@" = {
    overrideStrategy = "asDropin";
    requisite = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
