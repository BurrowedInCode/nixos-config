{ pkgs, ... }:

{
  imports = [
    ./niri
    ./plasma.nix
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "discord" ];

  environment.systemPackages = with pkgs; [
    brave
    (discord.override {
      commandLineArgs = "--ozone-platform=x11";
    })
  ];
}
