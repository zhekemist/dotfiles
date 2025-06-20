{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    curl
    git
    nixfmt-rfc-style
    wget
  ];

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  networking.hostId = "f7ceb750";
  networking.hostName = "cosmic-ac";

  networking.networkmanager.enable = true;

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
