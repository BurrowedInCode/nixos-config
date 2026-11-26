# nixos-config

Personal NixOS configurations using explicit module imports.

| Flake output | Host | Configuration |
| --- | --- | --- |
| `#nixos` | PC | Plasma and Niri, development tools, per-monitor layout |
| `#laptop` | Laptop | Plasma and Niri, development tools, laptop hardware |
| `#server` | Home server | Headless, SSH, Pi-hole in Docker; hardware placeholder |

## Layout

```text
flake.nix                         Inputs, host definitions, formatter
hosts/{pc,laptop,server}/
  default.nix                     Host imports, boot, networking, state version
  hardware-configuration.nix       Machine-specific hardware and filesystems
modules/
  system/base.nix                 Shared Nix settings, timezone, default locale
  system/default.nix              Workstation networking, locale, CLI tools
  users/coffeeg.nix                Desktop user account
  programs/development.nix         Development tools, Docker, development aliases
  programs/neovim/                 Neovim, language tools, writable LazyVim config
  programs/zellij/                 Optional Zellij setup (not currently imported)
  desktop/common.nix               Shared audio, printing, Firefox
  desktop/default.nix              PC desktop bundle: common, Plasma, Niri, apps
  desktop/plasma.nix               Plasma, SDDM, X11, PC session workaround
  desktop/niri/                    Niri, DMS, Ghostty, fonts, wallpaper, bindings
  server/pihole.nix                Pi-hole container and persistent storage
```

The PC imports the desktop bundle. The laptop imports the shared desktop pieces
directly and keeps its existing Plasma defaults, without the PC's extra apps,
Bluetooth settings, or session workarounds. The server imports only the system
base and Pi-hole; it does not enable NetworkManager or desktop/development tools.

Neovim's configuration is linked from
`/home/coffeeg/nixos-config/modules/programs/neovim/config` so LazyVim can update
its lockfile. User configuration paths and shell aliases intentionally assume
the `coffeeg` account and this checkout location.

## Rebuild and validate

Run these commands from the repository root. New files must be added to Git
before Git-backed flake commands can see them; committing is not required.

```sh
# Build without activating (use #laptop for the laptop).
nixos-rebuild build --flake .#nixos

# Activate on the target machine.
sudo nixos-rebuild switch --flake .#nixos

# Evaluate a host without building or activating.
nix eval --raw .#nixosConfigurations.nixos.config.system.build.toplevel.drvPath

# Format hand-maintained Nix files, leaving generated hardware files alone.
nix fmt -- flake.nix hosts/*/default.nix modules/*/*.nix modules/*/*/default.nix
```

The workstation `rebuild` alias uses the current hostname as the output name.
Keep the PC's hostname and output name `nixos` unchanged unless intentionally
renaming it. Keep every host's `system.stateVersion` at its installation value.

`nix flake check --no-build --no-write-lock-file` validates all hosts, but will
intentionally fail until the server's hardware placeholder is replaced. See
[the server guide](hosts/server/README.md) for installation, networking, Pi-hole,
and backup instructions.

## PC NVIDIA graphics

The PC's RTX 4060 uses NVIDIA's stable driver with the open kernel module,
Wayland modesetting, and 32-bit graphics libraries. These settings are in
`hosts/pc/default.nix`; the desktop allowlist permits NVIDIA's proprietary
userspace packages. The laptop and server do not enable the NVIDIA driver.

When changing from Nouveau, prepare the next boot instead of switching drivers
inside a running graphical session:

```sh
sudo nixos-rebuild boot --flake /home/coffeeg/nixos-config#nixos
sudo reboot
```

After reboot, `nvidia-smi` should show the RTX 4060. If the graphical session
fails, select the previous NixOS generation from the systemd-boot menu (hold
Space during startup to show it). A rebuild includes all pending configuration
changes in this checkout, not just the GPU settings.

## Add a host

1. Create `hosts/<name>/default.nix` and generate its own hardware configuration.
2. Import the shared modules needed for that machine. Use `modules/system/base.nix`
   for a minimal host or `modules/system` for workstation defaults.
3. Set its hostname, boot configuration, DNS, and initial `system.stateVersion`.
   Never copy another machine's disk UUIDs or assume its LAN DNS is appropriate.
4. Add `<name> = mkHost ./hosts/<name>;` to `nixosConfigurations` in `flake.nix`.
   The helper currently targets `x86_64-linux`; adapt it for another architecture.
5. Add the new files to Git, then run `nixos-rebuild build --flake .#<name>`.
