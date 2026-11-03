{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
    ../../modules/users/coffeeg.nix
    ../../modules/programs/development.nix
    ../../modules/programs/neovim
    ../../modules/programs/zellij
    ../../modules/desktop
  ];

  networking.hostName = "nixos";
  networking.nameservers = [
    "192.168.1.51"
    "192.168.1.52"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;

  environment.etc."niri/config.kdl".text = lib.mkBefore ''
    output "DP-1" {
        mode "2560x1440@164.983"
        scale 1
        position x=0 y=0
    }

    output "HDMI-A-1" {
        mode "1920x1080@60.000"
        scale 1
        position x=288 y=1440
    }
  '';

  # Keep the original installation version, independently of nixpkgs updates.
  system.stateVersion = "26.05";
}
