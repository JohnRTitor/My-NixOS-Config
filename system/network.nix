# Configure networking, firewall, proxy, etc.
{...}: {
  # Enable WIFI, Ethernet, ...
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd"; # newer backend

  services.resolved.enable = true; # enable systemd-resolved
  services.resolved.dnssec = "allow-downgrade"; # enable if available
  services.resolved.dnsovertls = "opportunistic"; # enable if available

  # DNS servers
  networking.nameservers = [
    "1.1.1.1" # Cloudflare DNS
    "1.0.0.1"
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
