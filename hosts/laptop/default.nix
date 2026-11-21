{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
    ../../modules/programs/neovim
    ../../modules/programs/development.nix
    ../../modules/users/coffeeg.nix
    ../../modules/desktop/common.nix
    ../../modules/desktop/niri
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop";
  networking.nameservers = [
    "192.168.1.51"
    "192.168.1.52"
  ];

  # Keep the laptop's Plasma defaults separate from the PC's session workaround.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.openssh.enable = true;

  # Keep the original installation version, independently of nixpkgs updates.
  system.stateVersion = "26.05";
}
