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

## Home Server

`#server` is a minimal headless configuration in `hosts/server`. It uses wired
DHCP, Cloudflare DNS (`1.1.1.1` and `1.0.0.1`), a disabled host firewall, and a
`coffeeg` administrator account, without desktop or development modules. It also
runs Pi-hole in Docker. Reserve `192.168.1.50` for the server's Ethernet MAC
address on your router; the host currently still uses DHCP, not a static address.

The initial assumptions are **x86-64 and UEFI boot**. Adjust the architecture in
`flake.nix` and the bootloader in `hosts/server/default.nix` if needed. The
hardware file is deliberately a placeholder that prevents installation until
replaced; no disk layout or formatting commands are assumed.

### First installation

1. Boot a NixOS installer USB on the server. Partition and mount its disks under
   `/mnt` using the NixOS installation guide, including the EFI partition at
   `/mnt/boot` for this bootloader. Formatting disks destroys their contents.
2. Generate the actual hardware configuration:

   ```sh
   sudo nixos-generate-config --root /mnt
   ```

3. Copy or clone this repository to `/mnt/etc/nixos` (preserving the generated
   files), then replace its server placeholder:

   ```sh
   sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/server/hardware-configuration.nix
   ```

4. Review the bootloader, architecture, timezone, and `system.stateVersion`
   before installing. This configuration starts at `26.05`. Add your SSH public
   key to `users.users.coffeeg.openssh.authorizedKeys.keys` if you want SSH later.
   Stage the configuration files so the Git-backed flake can see them:

   ```sh
   cd /mnt/etc/nixos
   sudo git add flake.nix hosts/server modules/server
   sudo nixos-install --flake /mnt/etc/nixos#server
   sudo nixos-enter --root /mnt -c 'passwd coffeeg'
   ```

5. Reboot into the installed system. The user password is for console login and
   `sudo`; SSH password login and root SSH login are disabled.

### Home-only access

The **host firewall is disabled**, so SSH and any future listening services are
reachable on connected networks. Add your public key before using SSH. Home-only
access depends on your router/network firewall: do not forward ports to this
server, and ensure unsolicited inbound IPv6 traffic is blocked too. A home
machine can have a publicly routable IPv6 address without IPv4 port forwarding.

Once the real hardware file is in place, validate and rebuild on the server:

```sh
sudo nixos-rebuild build --flake /etc/nixos#server
sudo nixos-rebuild switch --flake /etc/nixos#server
```

NixOS rollbacks do not back up service data. Add backups when you start storing
anything important on this machine.

### Pi-hole (Docker)

`modules/server/pihole.nix` runs the official `pihole/pihole:2026.11.0` image.
NixOS starts and supervises the container as `docker-pihole.service`; no Compose
commands are needed. Pi-hole forwards DNS to Cloudflare (`1.1.1.1` and `1.0.0.1`).
Your router remains the DHCP server, and the host itself continues using
Cloudflare directly so it can resolve names even if Pi-hole is unavailable.

After installing or rebuilding the server:

```sh
sudo systemctl status docker-pihole
sudo docker logs pihole
sudo docker exec -it pihole pihole setpassword
```

The last command prompts for an administrator password without putting it in
Git, the Nix store, or your shell history. Before you set it, Pi-hole generates a
random password on first startup and prints it in the container logs.

Once the server has `192.168.1.50`, open:

- `http://192.168.1.50:8080/admin/`
- `https://192.168.1.50:8443/admin/` (self-signed certificate warning expected)

DNS is published on **TCP and UDP port 53**. Web ports 8080/8443 leave 80/443
available for future services. Ensure nothing else on the host is listening on
these published ports. With the host firewall disabled, these ports are exposed
on all host interfaces: keep them private using your router/network firewall,
and never forward DNS port 53 from the internet.

Test from another LAN machine before changing router settings:

```sh
nslookup example.com 192.168.1.50
```

Then set your router's **LAN/DHCP DNS server** to `192.168.1.50` and renew client
leases. Do not advertise `1.1.1.1` as a secondary client DNS server: clients may
use it at any time and bypass filtering. Check IPv6 DNS advertisements and
client/browser encrypted DNS settings too, since those can bypass Pi-hole.

Persistent configuration, blocklists, and query data live in `/var/lib/pihole`.
Back this directory up before updates (stop `docker-pihole` while copying it for
a consistent backup). To upgrade, change the image tag in the module and rebuild
the server; do not use `pihole -up` inside the container. Configuration migrations
may prevent restoring an older image without restoring its matching data backup.
