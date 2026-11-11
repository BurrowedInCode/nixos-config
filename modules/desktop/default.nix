{ inputs, pkgs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfreePredicate =
      pkg: builtins.elem (pkgs.lib.getName pkg) [ "obsidian" ];
  };
in
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
    # Avoid the X11 bell module crashing when the display server exits.
    extraConfig.pipewire."99-disable-x11-bell"."context.properties"."module.x11.bell" = false;
  };

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "brave"
      "discord"
      "obsidian"
    ];

  environment.systemPackages = with pkgs; [
    brave
    unstable.obsidian
    vesktop
    (discord.override {
      commandLineArgs = "--ozone-platform=x11";
    })
  ];
}
