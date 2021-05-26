{ config, lib, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =[];

  homebrew = {
    enable = true;
    autoUpdate = true;
    casks = [
      "1password"
      "dash"
      "discord"
      "docker"
      "firefox-nightly"
      "iterm2"
      "raycast"
      "slack"
      "spotify"
    ];
    taps = [
      # "fewlines/tap"
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
    ];
    brews = [
      "mas"
      # "fewlines/tap/fwl_error"
    ];
    masApps = {
      "Spark" = 1176895641;
    };
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";
  environment.pathsToLink = [ "/share/zsh" ];

  nix.trustedUsers = [ "bastienriviere" ];

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;
  programs.nix-index.enable = true;

  home-manager.users.bastienriviere = {
    home.packages = let
      nvimConfig = pkgs.neovimUtils.makeNeovimConfig {
        withPython3 = true;
        withNodeJs = true;
        viAlias = true;
        vimAlias = true;
      };
      nvim = pkgs.wrapNeovimUnstable pkgs.neovim-nightly (nvimConfig // {
        wrapperArgs = (lib.escapeShellArgs nvimConfig.wrapperArgs);
      });
    in [
      nvim
      pkgs.tree-sitter

      pkgs.nix-prefetch-scripts
      pkgs.nixpkgs-review
      pkgs.sbcl
    ];
    home.stateVersion = "21.03";

    programs.direnv = {
      enable = true;
    };

    programs.fish = {
      enable = false;
    };

    programs.fzf = {
      enable = true;
    };

    programs.zsh = {
      # TODO: write configuration here
      enable = false;
      enableCompletion = true;
    };
  };

  users.users.bastienriviere = {
    name = "bastienriviere";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
