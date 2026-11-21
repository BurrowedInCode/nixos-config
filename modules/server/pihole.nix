{ config, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.pihole = {
      # Update this tag deliberately after reviewing the upstream release notes.
      image = "pihole/pihole:2026.11.0";
      autoStart = true;
      ports = [
        "53:53/tcp"
        "53:53/udp"
        "8080:80/tcp"
        "8443:443/tcp"
      ];
      environment = {
        TZ = config.time.timeZone;
        FTLCONF_dns_upstreams = "1.1.1.1;1.0.0.1";
        # Required for requests arriving over Docker's bridge network.
        FTLCONF_dns_listeningMode = "ALL";
      };
      # No password in Nix/the store: Pi-hole generates one on first startup.
      # Set your own interactively with `docker exec -it pihole pihole setpassword`.
      volumes = [ "/var/lib/pihole:/etc/pihole" ];
      # The router remains the DHCP server; no NET_ADMIN capability is needed.
    };
  };

  systemd.tmpfiles.rules = [ "d /var/lib/pihole 0750 root root -" ];
}
