# This conf file is used to configure user accounts in the system
{
  pkgs,
  pkgs-edge,
  systemSettings,
  userSettings,
  inputs,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.default ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      # Configure in ../pkgs/user-packages.nix
    ];
    # user shell changed to zsh
    shell = if (userSettings.shell == "zsh") then pkgs.zsh else pkgs.bash;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${userSettings.username} = import ../home-manager;
    extraSpecialArgs = {
      inherit inputs;
      inherit pkgs-edge;
      inherit systemSettings;
      inherit userSettings;
    };
  };
}
