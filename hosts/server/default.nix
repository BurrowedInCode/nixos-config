{ lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/server/pihole.nix
  ];

  # Assumes UEFI boot. Replace with the appropriate loader for a BIOS machine.
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  networking.hostName = "server";
  # Wired Ethernet, with an address and gateway supplied by the home router.
  networking.useDHCP = lib.mkDefault true;
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  # Keep DHCP-provided DNS from replacing the nameservers above.
  networking.dhcpcd.extraConfig = "nohook resolv.conf";
  networking.firewall.enable = false;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.coffeeg = {
    isNormalUser = true;
    description = "houssine";
    extraGroups = [ "wheel" ];
    # Add your public key before enabling remote access. Never add a private key.
    openssh.authorizedKeys.keys = [ ];
  };

  services.openssh = {
    enable = true;
    # Do not add firewall rules; the host firewall is disabled above.
    openFirewall = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  # Set a local password with `passwd coffeeg` during installation (for sudo).
  # Keep this at the initial installation version, even after future upgrades.
  system.stateVersion = "26.05";
}
