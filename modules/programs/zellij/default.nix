{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.zellij ];

  environment.etc."zellij/config.kdl".source = ./config.kdl;

  systemd.tmpfiles.rules = [
    "d /home/coffeeg/.config/zellij 0755 coffeeg users - -"
    "L+ /home/coffeeg/.config/zellij/config.kdl - - - - /etc/zellij/config.kdl"
  ];
}
