{
  config,
  inputs,
  lib,
  pkgs,
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

        ".local/share/direnv/allow"

        ".mozilla"

        ".local/share/PrismLauncher"

        ".local/share/TelegramDesktop"

        ".config/ticktick"

        ".config/Code"
        ".vscode"

        ".zotero"
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
      files = [
        ".ssh/id_ecdsa.pub"
        ".ssh/id_ecdsa.tpm"
        ".ssh/known_hosts"
      ];
    };
  };

  fileSystems."/state".neededForBoot = true;
  fileSystems."/persist".neededForBoot = true;
}
