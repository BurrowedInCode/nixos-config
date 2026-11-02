{ pkgs, ... }:

{
  users.users.coffeeg = {
    isNormalUser = true;
    description = "houssine";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = [ pkgs.kdePackages.kate ];
  };
}
