{ pkgs, inputs, ... }:

{
  programs.niri.enable = true;

  systemd.user.services.niri = {
    environment.NIRI_CONFIG = "/etc/niri/config.kdl";
    restartIfChanged = false;
  };

  programs.dms-shell = {
    enable = true;
    package = inputs.dms.lib.mkDmsShell pkgs;

    systemd = {
      enable = true;
      restartIfChanged = true;
      target = "niri.service";
    };

    enableSystemMonitoring = true;
    enableDynamicTheming = true;
    enableCalendarEvents = true;
  };

  environment.systemPackages = with pkgs; [
    (symlinkJoin {
      name = "ghostty-configured";
      paths = [ ghostty ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/ghostty" --add-flags "--config-file=/etc/ghostty/config"
      '';
    })
    wl-clipboard
    xwayland-satellite
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    material-symbols
  ];

  systemd.tmpfiles.rules = [
    "d /home/coffeeg/.config/dms 0755 coffeeg users - -"
    "d /home/coffeeg/.config/dms/config.d 0755 coffeeg users - -"
    "L+ /home/coffeeg/.config/dms/config.d/90-fonts.json - - - - /etc/dms/fonts.json"
  ];

  environment.etc."dms/fonts.json".text = builtins.toJSON {
    fontFamily = "JetBrainsMono Nerd Font";
    monoFontFamily = "JetBrainsMono Nerd Font";
  };
  environment.etc."niri/config.kdl".text = builtins.readFile ./config.kdl;
  environment.etc."wallpapers/nix.jpg".source = ./wallpaper.jpg;
  environment.etc."ghostty/config".text = ''
    theme = "Rose Pine"
    font-family = JetBrainsMono Nerd Font
    background-opacity = 0.9
    window-padding-x = 12
    window-padding-y = 12
  '';

  security.pam.services.dankshell = { };
}
