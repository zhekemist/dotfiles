{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.system;
        config.allowUnfree = final.config.allowUnfree;
      };
    })
  ];
}
