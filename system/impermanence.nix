{
  config,
  inputs,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r zroot/root@blank
  '';

  environment.persistence."/state" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/log"
    ];
    files = [ "/etc/machine-id" ];
    users.tobias = {
      directories = [
        ".config/calibre"

        ".config/discord"

        ".mozilla"

        ".local/share/TelegramDesktop"

        ".config/ticktick"

        ".config/Code"
        ".vscode"
      ];
      files = [ ];
    };
  };

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [ ];
    files = [ ];
    users.tobias = {
      directories = [
        ".ssh"

        "archive"
        "dotfiles"
        "projects"

        "desktop"
        "documents"
        "downloads"
        "music"
        "pictures"
        "public"
        "templates"
        "videos"
      ];
      files = [ ];
    };
  };

  fileSystems."/state".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;
}
