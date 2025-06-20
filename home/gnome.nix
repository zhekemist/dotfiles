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
      "file:///home/tobias/desktop"
      "file:///home/tobias/documents/university/applications/masters"
      "file:///home/tobias/projects/dynamic-high-dimensional-spanners dynhds"
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
        name = "Launch emacs";
        binding = "<Super>e";
        command = "emacs";
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
