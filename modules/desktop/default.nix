{ inputs, pkgs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "obsidian" ];
  };
in
{
  imports = [
    ./common.nix
    ./niri
    ./plasma.nix
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Avoid the X11 bell module crashing when the display server exits.
  services.pipewire.extraConfig.pipewire."99-disable-x11-bell"."context.properties"."module.x11.bell" =
    false;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "brave"
      "discord"
      "nvidia-x11"
      "nvidia-settings"
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
