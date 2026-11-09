{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.zellij ];

  programs.bash.interactiveShellInit = ''
    if [[ "$USER" == "coffeeg" && -t 0 && -t 1 && -z "''${ZELLIJ:-}" && "''${TERM:-dumb}" != "dumb" ]]; then
      exec ${pkgs.zellij}/bin/zellij
    fi
  '';

  environment.etc."zellij/config.kdl".source = ./config.kdl;
  environment.etc."zellij/layouts/minimal.kdl".text = ''
    layout {
      default_tab_template {
        children
      }
      pane
    }
  '';

  systemd.tmpfiles.rules = [
    "d /home/coffeeg/.config/zellij 0755 coffeeg users - -"
    "L+ /home/coffeeg/.config/zellij/config.kdl - - - - /etc/zellij/config.kdl"
  ];
}
