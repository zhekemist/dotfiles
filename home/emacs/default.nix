{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  programs.emacs = {
    enable = true;
    extraPackages =
      epkgs: with epkgs; [
        auctex
        cdlatex
        ligature
        org-appear
        org-fragtog
        org-modern
        org-roam
        pdf-tools
        solarized-theme
        yasnippet
      ];
  };

  home.file.".config/emacs" = {
    source = ./config;
  };
}
