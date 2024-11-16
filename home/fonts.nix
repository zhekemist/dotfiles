{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  fonts.fontconfig.enable = true;

  home.packages =
    with pkgs;
    let
      commonBuildPlan = {
        serifs = "sans";
        variants.inherits = "ss05";
        ligations.inherits = "dlig";
      };
    in
    [
      (iosevka.override {
        set = "Standard";
        privateBuildPlan = commonBuildPlan // {
          family = "Iosevka";
          spacing = "normal";
        };
      })
      (iosevka.override {
        set = "Quasi-Proportional";
        privateBuildPlan = commonBuildPlan // {
          family = "Iosevka Aile";
          spacing = "quasi-proportional";
        };
      })
    ];
}
