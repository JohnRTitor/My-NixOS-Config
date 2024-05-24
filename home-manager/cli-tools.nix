{pkgs, ...}: {
  # Configure nnn - the terminal file manager
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override {withNerdIcons = true;};
    extraPackages = with pkgs; [
      ffmpegthumbnailer
      mediainfo
      sxiv
    ];
  };

  # Configure fzf - a command-line fuzzy finder
  programs.fzf.enable = true;

  # Configure eza - a modern replacement for ls
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

  # Configure zoxide - A smarter cd command which learns your habits as you go
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd" # Replace cd with zoxide
    ];
  };
}
