# nixos-config

Personal NixOS configuration. The current PC is built as `#nixos`; no laptop
configuration is defined yet.

## Layout

```text
flake.nix                         Inputs and host outputs
hosts/pc/
  default.nix                     PC imports, boot, hostname, DNS, monitors, SSH
  hardware-configuration.nix       Generated hardware and filesystem settings
modules/
  system/default.nix              Nix, networking, locale, basic CLI tools
  users/coffeeg.nix                User account
  programs/development.nix         Development tools and OpenCode settings
  programs/neovim/                 Neovim, language tools, writable LazyVim config
  desktop/default.nix              Audio, Bluetooth, printing, desktop apps
  desktop/plasma.nix               Plasma, SDDM, X11
  desktop/niri/                    Niri, DMS, Ghostty, fonts, wallpaper, bindings
```

These are ordinary NixOS modules, enabled through explicit `imports`. Importing
`modules/desktop` currently enables both Plasma and Niri, matching the existing PC
setup. Niri's shared configuration lives next to its module; the PC module adds
the monitor layout.

Neovim's configuration is linked from
`/home/coffeeg/nixos-config/modules/programs/neovim/config` so LazyVim can update
its lockfile. The checkout location and username are intentionally personal, not
generic module parameters. The first rebuild replaces the old Neovim symlink.

## Rebuild

```sh
sudo nixos-rebuild switch --flake /home/coffeeg/nixos-config#nixos
```

The `rebuild` shell alias uses the current hostname as the flake output name.
New files must be added to Git before normal Git-backed flake commands can see
them; committing is not required.

To evaluate without activating:

```sh
nix flake check --no-build --no-write-lock-file
nix build --no-link --no-write-lock-file .#nixosConfigurations.nixos.config.system.build.toplevel
```

## Adding A Laptop

1. Create `hosts/laptop/default.nix` and generate its own hardware configuration.
2. Import the shared modules you want, as the PC does. Import only the desired
   desktop session modules if you do not want both Plasma and Niri.
3. Set the laptop's hostname, boot configuration, monitor layout if needed, and
   its own initial `system.stateVersion`. Do not copy the PC's disk UUIDs or LAN DNS.
4. Add `nixosConfigurations.laptop` in `flake.nix`, using the laptop's architecture,
   `specialArgs = { inherit inputs; };`, and `modules = [ ./hosts/laptop ];`.
5. Add the new files to Git, then run `nixos-rebuild build --flake .#laptop`.

Keep the PC's hostname and output name `nixos` unchanged unless intentionally
renaming it. Keep each machine's `system.stateVersion` at its installation value.
