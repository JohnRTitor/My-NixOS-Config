{
  # initial commands to run for all shells
  commonRcExtra = ''
    # Custom extraRc from home-manager/shell.nix

    execmd() { echo "Executing: $@" && "$@" ; } # wrapper to print command before executing it

    getpkgs() { # Construct a getpkgs wrapper of nom shell
        local command="env NIXPKGS_ALLOW_UNFREE=1 nom shell --impure"
        for arg in "$@"; do # loop through all package names given as args
            command+=" nixpkgs#$arg"
        done
        eval "execmd $command"
    } # now you can run `getpkgs package1 package2 package3` to get a nix shell
  '';

  # Define common aliases which would apply to all shells
  commonAliases = {
    check-flake = "execmd nix flake check";
    update-flake = "execmd nix flake update";
    # update-flake-input = "nix flake lock --update-input";
    # rebuild = "execmd sudo nixos-rebuild switch";
    # garbage-collect = "execmd sudo nix-collect-garbage -d";
    fix-store = "execmd sudo nix-store --verify --check-contents --repair";
    # cfastfetch is just an alias to run compact fastfetch
    cfastfetch = "fastfetch --config ~/.config/fastfetch/config-compact.jsonc";
  };

  # Define common session variables which would apply to all shells
  commonSessionVariables = {
    # Binds GPG to current tty
    GPG_TTY = "$(tty)";
    # Add custom bin directories to the PATH
    PATH = "$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin";
  };
}
