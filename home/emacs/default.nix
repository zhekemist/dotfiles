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
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./config/init.el;
      alwaysEnsure = true;
      extraEmacsPackages = epkgs: with epkgs; [
        use-package
      ];
    };
  };

  home.file.".config/emacs" = {
    source = ./config;
  };
}
