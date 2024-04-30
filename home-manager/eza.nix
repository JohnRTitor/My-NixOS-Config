# Configure eza - a modern replacement for ls
{ pkgs, ... }:
{
  programs.eza = {
    enable = true;
    icons = true;
    git = true;
    extraOptions = [
      # extra flags to pass to eza
      "--git-repos" # show git directories repo status
      "--hyperlink" # display results as hyperlinks
    ];
    # disabled as some scripts may not work with eza
    enableBashIntegration = false;
  };
}
