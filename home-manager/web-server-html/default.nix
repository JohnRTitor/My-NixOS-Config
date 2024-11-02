# this config file places relevant files in the home directory
# for the nginx localhost webserver
# THIS ONLY PLACES THE CONFIG FILES, DOES NOT INSTALL NGINX
# For that see ../../dev-environment/nginx.nix
# Import of thie module is controlled by bool: servicesSettings.nginx
{pkgs, ...}:
let
  # Updated adminer
  adminer-new = pkgs.fetchurl {
    url = "https://github.com/pematon/adminer/releases/download/v4.10/adminer-4.10-mysql.php";
    hash = "sha256-A36I2Ffmex5TjRt+Ee915psJILcBrM9hSCmR0TGVCgo=";
  };
  adminer-new-plugin-php = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/pematon/adminer/refs/tags/v4.10/plugins/plugin.php";
    hash = "sha256-67qBEimeesKSCKwaSLQK7u/6lxnZ0+jpuJXqdIqaNCY=";
  };
  adminer-theme = pkgs.fetchFromGitHub {
    owner = "pematon";
    repo = "adminer-theme";
    rev = "v1.8.1";
    hash = "sha256-Ax0UfqBF7xzYDGU5OlYCxq+9SzvXw7/WI7GJiXpZXBk=";
  };
  
in {
  home.file = {
    "Website-Instances/index.php".source = ./index.php;
    "Website-Instances/logos/nginx-logo.png".source = ./logos/nginx-logo.png;
    "Website-Instances/logos/nixos-logo.png".source = ./logos/nixos-logo.png;

    # To use adminer, just type localhost/dbms/adminer.php in your browser
    # This configuration automatically places the php file in the correct location
    "Website-Instances/adminer/adminer.php".source = adminer-new;

    # Adminer theme
    "Website-Instances/adminer/index.php" = {
      source = ./adminer/index.php;
    };
    "Website-Instances/adminer/css" = {
      source = "${adminer-theme}/lib/css";
      recursive = true;
    };
    "Website-Instances/adminer/fonts" = {
      source = "${adminer-theme}/lib/fonts";
      recursive = true;
    };
    "Website-Instances/adminer/images" = {
      source = "${adminer-theme}/lib/images";
      recursive = true;
    };
    "Website-Instances/adminer/plugins/AdminerTheme.php" = {
      source = "${adminer-theme}/lib/plugins/AdminerTheme.php";
    };
    "Website-Instances/adminer/plugins/plugin.php" = {
      source = adminer-new-plugin-php;
    };
  };
}
