{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ ./base.nix ];

  programs.bash.shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/coffeeg/nixos-config#${config.networking.hostName}";

  networking.networkmanager.enable = true;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    fastfetch
    git
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default # default, beta, twilight, or twilight-official
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
