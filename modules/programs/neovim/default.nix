{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    gopls
    nixd
    lua-language-server
    typescript-language-server
    prettier
    nixfmt
    stylua
    shfmt
    tree-sitter
  ];

  # LazyVim needs a writable configuration and plugin lockfile in the checkout.
  systemd.tmpfiles.rules = [
    "d /home/coffeeg/.config 0755 coffeeg users - -"
    "L+ /home/coffeeg/.config/nvim - - - - /home/coffeeg/nixos-config/modules/programs/neovim/config"
  ];
}
