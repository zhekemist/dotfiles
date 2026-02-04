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

    ./zshell
  ];

  home.username = "tobias";
  home.homeDirectory = "/home/tobias";

  home.packages = with pkgs.unstable; [
    age
    anki
    calibre
    discord
    firefox
    jetbrains-toolbox
    libreoffice-fresh
    mattermost-desktop
    poppler-utils
    telegram-desktop
    texliveFull
    texstudio
    ticktick
    uv
    vdhcoapp
    vscode
    xsel
    zotero

    (prismlauncher.override {
      jdks = with javaPackages.compiler; [
        temurin-bin.jre-17
        temurin-bin.jre-21
        temurin-bin.jre-25
      ];
      additionalLibs = with pkgs; [
        glib
        nspr
        nss
        dbus
        atk
        at-spi2-atk
        cups
        libgbm
        expat
        libxkbcommon
        cairo
        pango
        systemd
        alsa-lib
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        xorg.libxcb
      ];
    })
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
    settings = {
      user = {
        name = "Tobias";
        email = "79578794+zhekemist@users.noreply.github.com";
      };
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
      "*" = {
        userKnownHostsFile = "/persist/home/tobias/.ssh/known_hosts";
        serverAliveInterval = 60;
        serverAliveCountMax = 10;
      };
      minecraft-server = {
        hostname = "130.162.32.127";
        user = "opc";
        port = 22;
      };
      univie-par-alma = {
        hostname = "alma.par.univie.ac.at";
        user = "a11743321";
      };
    };
    enableDefaultConfig = false;
  };

  xdg.userDirs = {
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
      "application/pdf" = "org.gnome.Papers.desktop";
      "application/vnd.oasis.opendocument.text" = "writer.desktop";
      "text/markdown" = "org.gnome.TextEditor.desktop";
      "text/plain" = "org.gnome.TextEditor.desktop";
      "text/x-tex" = "texstudio.desktop";
      "text/html" = "firefox.desktop";
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
