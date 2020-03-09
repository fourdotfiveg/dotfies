{ config, lib, pkgs, ... }:

with lib;

let
  dotfiles = config.dotfiles;
  cfg = dotfiles.desktop.fonts;
  unstable = import <nixpkgs-unstable> { };

  ## Build options
  mkFont = name: pkg: desc:
    mkOption {
      type = types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "Font name for ${desc}";
            default = name;
          };
          package = mkOption {
            type = types.package;
            description = "Font package for ${desc}";
            default = pkg;
          };
        };
      };
      description = "Font for ${desc}";
      default = {
        name = name;
        package = pkg;
      };
    };
in {
  # TODO: use an enum for fonts ?
  # TODO: add fontconfig for each font. e.g font size for emacs, rofi and else
  options.dotfiles.desktop.fonts = {
    # term = mkFont "Jetbrains Mono" unstable.jetbrains-mono
    #   "terminal font (no ligature)";
    #mono = mkFont "Jetbrains Mono" unstable.jetbrains-mono "monospaced font";
    term = mkFont "JetBrainsMono Nerd Font"
      (unstable.nerdfonts.override { withFont = "JetBrainsMono"; }) "term font";
    mono = mkFont "JetBrainsMono Nerd Font"
      (unstable.nerdfonts.override { withFont = "JetBrainsMono"; })
      "monospaced font";
    sansSerif = mkFont "Roboto" pkgs.roboto "sans serif font";
    serif = mkFont "Roboto Slab" pkgs.roboto-slab "serif font";

    ligature = mkEnableOption "ligature";
  };

  config = {
    fonts = {
      fontconfig = {
        enable = true;
        defaultFonts = {
          monospace = [ cfg.mono.name ];
          sansSerif = [ cfg.sansSerif.name ];
          serif = [ cfg.serif.name ];
        };
      };
      fonts = [
        cfg.mono.package
        cfg.term.package
        cfg.sansSerif.package
        cfg.serif.package
        pkgs.nur.repos.babariviere.nerd-font-symbols
      ];
      enableDefaultFonts = true;
    };
  };
}