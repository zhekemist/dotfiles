{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    dconf-editor

    gnomeExtensions.appindicator
    gnomeExtensions.pop-shell

    unstable.gnome-pomodoro
  ];

  gtk = {
    enable = true;
    gtk3.bookmarks = [
      "file:///home/tobias/documents/university/current-courses courses"
      "file:///home/tobias/desktop"
    ];
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          pop-shell.extensionUuid
          appindicator.extensionUuid

          "pomodoro@arun.codito.in"
        ];
        favorite-apps = [
          "firefox.desktop"
          "org.gnome.Console.desktop"
          "org.gnome.Nautilus.desktop"
        ];
        welcome-dialog-last-shown-version = 999;
      };

      # remove all folders in the app overview
      "org/gnome/desktop/app-folders/folders" = {
        folder-children = [ ];
      };

      "org/gnome/desktop/background" = {
        picture-uri = "${../assets/pillars_of_creation.jpg}";
      };

      # custom keybindings
      "org/gnome/settings-daemon/plugins/media-keys" = {
        help = [ ]; # launch help
        www = [ "<Super>b" ]; # launch browser
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Launch console";
        binding = "<Super>t";
        command = "kgx";
      };
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "Launch Visual Studio Code";
        binding = "<Super>c";
        command = "code";
      };

      "org/gnome/mutter" = {
        dynamic-workspaces = true;
        workspaces-only-on-primary = false;

        edge-tiling = false; # required by popshell's tiling mode
      };

      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = true;
      };

      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "list-view";
      };

      "ca/desrt/dconf-editor" = {
        show-warning = false;
      };
    };
  };
}
