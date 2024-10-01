{
  config,
  inputs,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  imports = [ ./gnome.nix ];

  home.username = "tobias";
  home.homeDirectory = "/home/tobias";

  home.packages =
    (with pkgs; [
      calibre
      emacs
      firefox
      vscode
      xsel
    ])
    ++ (with pkgs-unstable; [
      discord
      telegram-desktop
      ticktick
    ]);

  programs.bash = {
    enable = true;
    shellAliases = {
      l = "ls -alh";
      ll = "ls -l";
      ls = "ls --color=tty";
      nxo-rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles";
    };
  };

  programs.git = {
    enable = true;
    userName = "Tobias";
    userEmail = "79578794+zhekemist@users.noreply.github.com";
    extraConfig = {

    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      IdentityAgent = "''${XDG_RUNTIME_DIR}/ssh-tpm-agent.sock"
      IdentityFile = "~/.ssh/id_ecdsa.pub"
    '';
    matchBlocks = {
      minecraft-server = {
        hostname = "130.162.32.127";
        user = "opc";
        port = 22;
      };
    };
  };

  xdg.userDirs =
    {
      enable = true;
    }
    // builtins.mapAttrs (_: value: "${config.home.homeDirectory}/${value}") {
      desktop = "desktop";
      documents = "documents";
      download = "downloads";
      music = "music";
      pictures = "pictures";
      publicShare = "public";
      templates = "templates";
      videos = "videos";
    };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.gnome.Evince.desktop";
      "text/markdown" = "org.gnome.TextEditor.desktop";
      "text/plain" = "org.gnome.TextEditor.desktop";
    };
  };

  home.file.".clang-format" = {
    text = ''
      BasedOnStyle: Chromium
      BreakBeforeBraces: Stroustrup
      AccessModifierOffset: -2
      IndentWidth:	4
    '';
  };

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
