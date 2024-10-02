# this config file places relevant files in the home directory
# for the nginx localhost webserver
# THIS ONLY PLACES THE CONFIG FILES, DOES NOT INSTALL NGINX
# For that see ../../dev-environment/nginx.nix
# Import of thie module is controlled by bool: servicesSettings.nginx
{pkgs, ...}: {
  home.file = {
    "Website-Instances/index.php".source = ./index.php;
    "Website-Instances/logos/nginx-logo.png".source = ./logos/nginx-logo.png;
    "Website-Instances/logos/nixos-logo.png".source = ./logos/nixos-logo.png;

    # To use adminer, just type localhost/adminer.php in your browser
    # This configuration automatically places the php file in the correct location
    "Website-Instances/adminer.php".source = "${pkgs.adminer}/adminer.php";
  };
}
