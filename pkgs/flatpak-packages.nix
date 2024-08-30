{
  systemPackages = [
    # Flatpak packages to be installed systemwide
    "com.github.tchx84.Flatseal" # Customising permission of Flatpaks
    "io.github.zen_browser.zen" # Zen Browser
  ];

  userPackages = [
    # Flatpak packages to be installed on a per user basis
    "io.github.tdesktop_x64.TDesktop" # 64Gram
    "im.riot.Riot" # Element Matrix Client
    "dev.vencord.Vesktop" # Vesktop
  ];
}
