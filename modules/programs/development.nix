{ pkgs, inputs, ... }:

{
  virtualisation.docker.enable = true;
  users.users.coffeeg.extraGroups = [ "docker" ];

  programs.bash.shellAliases.coa-db = "docker compose -f /home/coffeeg/repos/cannabis_coa_analyzer/docker-compose.yml exec postgres psql -U admin -d cannabis_coa_analyzer";

  environment.systemPackages = with pkgs; [
    go_1_27
    rustc
    cargo
    clippy
    rustfmt
    nodejs
    pnpm
    typescript
    lazygit
    lazydocker
    bruno
    ripgrep
    fd
    gcc
    gnumake
    unzip
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.herdr
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.opencode
  ];

  environment.variables.RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

  systemd.tmpfiles.rules = [
    "d /home/coffeeg/.config/opencode 0755 coffeeg users - -"
    "L+ /home/coffeeg/.config/opencode/tui.json - - - - /etc/opencode/tui.json"
  ];

  environment.etc."opencode/tui.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/tui.json";
    theme = "system";
  };
}
