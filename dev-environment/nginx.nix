{
  config,
  pkgs,
  lib,
  userSettings,
  ...
}: {
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx.enable = true;
  services.nginx.recommendedTlsSettings = true;
  services.nginx.recommendedOptimisation = true;
  services.nginx.recommendedProxySettings = true;
  services.nginx.recommendedZstdSettings = true;

  services.nginx.virtualHosts."localhost" = {
    # addSSL = true;
    # enableACME = true; # for automatic certificate generation
    root = "/var/www/localhost";
  };

  /*
  security.acme = {
    acceptTerms = true;
    defaults.email = userSettings.email;
  };
  */

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    settings.mysqld.bind-address = "localhost";
  };

  systemd.tmpfiles.rules = [
    "d /var/www/localhost"
    "f /var/www/localhost/index.php - - - - <?php phpinfo();>"
  ];

  # hacky way to create our directory structure and index page... don't actually use this
  # systemd.tmpfiles.rules = [
  #   "d /var/www/example.org"
  #   "f /var/www/example.org/index.php - - - - <?php phpinfo();"
  # ];
}
