{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    go_1_27
    nodejs
    typescript
    lazygit
    ripgrep
    fd
    gcc
    gnumake
    unzip
    opencode
  ];

  systemd.tmpfiles.rules = [
    "d /home/coffeeg/.config/opencode 0755 coffeeg users - -"
    "L+ /home/coffeeg/.config/opencode/tui.json - - - - /etc/opencode/tui.json"
  ];

  environment.etc."opencode/tui.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/tui.json";
    theme = "system";
  };
}
