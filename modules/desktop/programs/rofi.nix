{ config, lib, pkgs, ... }:

let
  dotfiles = config.dotfiles;
  cfg = dotfiles.desktop.rofi;
in {
  options.dotfiles.desktop.rofi.enable = lib.mkEnableOption "rofi";

  config = lib.mkIf (dotfiles.desktop.enable && cfg.enable) {
    environment.systemPackages = with pkgs; [ rofi ];

    home-manager.users."${dotfiles.user}".xdg.configFile = {
      "rofi/config.rasi".source = pkgs.mutate <config/rofi/config.rasi> {
        theme = dotfiles.theme;
        terminal = "${pkgs.termite}/bin/termite";
        font = dotfiles.desktop.fonts.mono.name;
      };

      "rofi/${dotfiles.theme}.rasi".source =
        pkgs.mutate <config/rofi/theme.rasi> dotfiles.colors;
    };
  };
}
