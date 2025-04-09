{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./fonts.nix
    ./gnome.nix

    ./emacs
    ./zshell
  ];

  home.username = "tobias";
  home.homeDirectory = "/home/tobias";

  home.packages = with pkgs; [
    age
    calibre
    firefox
    libreoffice-fresh
    poppler_utils
    vscode
    xsel

    unstable.anki
    unstable.discord
    unstable.prismlauncher
    unstable.telegram-desktop
    unstable.texliveFull
    unstable.texstudio
    unstable.ticktick
    unstable.zotero
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    config = {
      global = {
        warn_timeout = 0;
        hide_env_diff = true;
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Tobias";
    userEmail = "79578794+zhekemist@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
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
      "application/vnd.oasis.opendocument.text" = "writer.desktop";
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
