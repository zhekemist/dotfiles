{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      l = "ls -alh";
      ll = "ls -l";
      ls = "ls --color=tty";
      rebuild-os = "sudo nixos-rebuild switch --flake ~/dotfiles";
    };

    initContent =
      let
        zshrc = pkgs.replaceVars ./zshrc {
          flakeTemplate = ../../templates/project-flake.nix;
        };
      in
      ''
        # Custom .zshrc (see dotfiles > home > zshell)
        source ${zshrc} 
      '';
  };
}
