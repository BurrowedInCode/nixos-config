{ pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  programs.niri.enable = true;

  programs.dms-shell = {
    enable = true;

    systemd = {
    	enable = true;
	restartIfChanged = true;
	target = "niri.service";
    };
    
    enableSystemMonitoring = true;
    enableDynamicTheming =  true;
    enableCalendarEvents =  true;
  };

  environment.systemPackages = with pkgs; [
    ghostty
    wl-clipboard
    xwayland-satellite
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    material-symbols
  ];

  environment.etc."niri/config.kdl".source = ./niri-config.kdl;

  security.pam.services.dankshell = {};
}
