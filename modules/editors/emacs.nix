{ config, lib, pkgs, ... }:

with lib;
let
  dotfiles = config.services.dotfiles;
  cfg = dotfiles.editors.emacs;
  rg = (pkgs.ripgrep.override { withPCRE2 = true; });
  unstable = import <nixpkgs-unstable> { };
in {
  # TODO: install doom config via home-manager
  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        (mkIf (config.programs.gnupg.agent.enable) pinentry_emacs)

        # Essential
        unstable.emacs
        (mkIf (cfg.editorconfig) editorconfig-core-c) # :tools editorconfig

        # Misc
        texlive.combined.scheme-medium # :lang org
        (mkIf (cfg.ripgrep) rg)
      ];

      sessionVariables = { EDITOR = "emacs"; };

      shellAliases = { e = "emacs"; };
    };

    fonts.fonts = [ pkgs.emacs-all-the-icons-fonts ];

    home-manager.users."${dotfiles.user}".xdg.configFile = {
      "zsh/rc.d/env.emacs.zsh".source = <config/emacs/env.zsh>;
    };
  };
}
