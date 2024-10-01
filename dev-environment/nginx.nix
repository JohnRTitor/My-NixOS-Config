{
  config,
  pkgs,
  lib,
  userSettings,
  ...
}: {
  services.nginx = {
    enable = true;
    virtualHosts.localhost = {
      locations."/wiki" = {
        return = "200 '<html><body>It works<br><?php phpinfo();></body></html>'";
        extraConfig = ''
          default_type text/html;
        '';
      };
    };
  };

  environment.systemPackages = [ pkgs.php ];
}
