{ config, pkgs, lib, userSettings, ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.nginx.enable = true;
  services.nginx.virtualHosts."johnrtitor.org" = {
      # addSSL = true;
      # enableACME = true; # for automatic certificate generation
      root = "/var/www/johnrtitor.org";
  };
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = userSettings.email;
  # };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    settings.mysqld.bind-address = "localhost";
  };

  # hacky way to create our directory structure and index page... don't actually use this
  # systemd.tmpfiles.rules = [
  #   "d /var/www/example.org"
  #   "f /var/www/example.org/index.php - - - - <?php phpinfo();"
  # ];
}