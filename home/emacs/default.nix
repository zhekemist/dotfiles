{
  config,
  inputs,
  lib,
  pkgs,
  pkgs-unstable,
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
        pdf-tools
        solarized-theme
        yasnippet
      ];
  };

  home.file.".config/emacs" = {
    source = ./config;
  };
}
