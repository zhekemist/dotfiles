{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # keyboard layout
  services.xserver.xkb = {
    layout = "at";
    variant = "";
    options = "ctrl:nocaps";
  };

  # exclude any unneeded bloatware
  services.xserver.excludePackages = [ pkgs.xterm ];
  environment.gnome.excludePackages = with pkgs; [
    gnome-connections
    gnome-tour

    baobab # disk usage analyzer
    cheese # photo booth
    epiphany # web browser
    totem # video player
    yelp # help viewer
    file-roller # archive manager
    geary # email client
    seahorse # password manager

    gnome-calendar
    gnome-clocks
    gnome-contacts
    gnome-logs
    gnome-maps
    gnome-music
    gnome-system-monitor
    gnome-weather
  ];

}
