{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./big-ip-edge-client.nix
    ./desktop-environment.nix
    ./disk-configuration.nix
    ./hardware-configuration.nix
    ./impermanence.nix
    ./overlays.nix
    ./tpm-sealed-ssh.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.reusePassphrases = true;

  users.mutableUsers = false;
  users.users = {
    root = {
      hashedPassword = "*"; # disable root login
    };
    tobias = {
      isNormalUser = true;
      description = "Tobias";
      extraGroups = [
        "networkmanager"
        "wheel" # for `sudo`
        "lp" # scanners
      ];
      hashedPassword = builtins.readFile inputs.user-password;
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    devenv
    git
    nixfmt-rfc-style
    wget
  ];

  programs.nix-ld.enable = true;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.gamemode = {
    enable = true;

    settings.custom = {
      start = "${pkgs.libnotify}/bin/notify-send 'GameMode activated!'";
      end = "${pkgs.libnotify}/bin/notify-send 'GameMode deactivated!'";
    };
  };

  networking.hostId = "f7ceb750";
  networking.hostName = "cosmic-ac";

  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [ 50000 ];

  services.nginx = {
    enable = true;
    virtualHosts.localhost = {
      root = "/home/tobias/public";
      listen = [
        {
          addr = "0.0.0.0";
          port = 50000;
        }
      ];
      locations."/" = {
        extraConfig = ''
          autoindex on;
          allow 10.0.0.0/8;
          allow 172.16.0.0/12;
          allow 192.168.0.0/16;
          deny all;
        '';
      };
    };
  };
  systemd.services.nginx.serviceConfig.ProtectHome = "read-only";

  big-ip-edge-client.enable = true;

  time.timeZone = "Europe/Vienna";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.extraConfig.wireplumber = {
      "wireplumber.settings"."device.routes.default-sink-volume" = "0.0";
    };
  };

  hardware.bluetooth.powerOnBoot = false;

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    canon-cups-ufr2
  ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];

  services.zfs.trim.enable = true;

  services.zfs.autoSnapshot.enable = true;

  security.rtkit.enable = true;

  zramSwap.enable = true;

  system.stateVersion = "24.05";
}
