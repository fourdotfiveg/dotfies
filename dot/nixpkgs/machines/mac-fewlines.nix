{ config, inputs, lib, pkgs, ... }:

let
  # emacs = config.home-manager.users.bastienriviere.programs.emacs.package;
  emacs = pkgs.emacsOsx;
in {
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = [
    # emacs
  ];

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
    masApps = { "Spark" = 1176895641; };
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";
  environment.pathsToLink = [ "/share/zsh" ];

  nix.trustedUsers = [ "bastienriviere" ];

  launchd.daemons = {
    limits = {
      script = ''
        launchctl limit maxfiles 524288 524288
        launchctl limit maxproc 8192 8192
      '';
      serviceConfig.RunAtLoad = true;
      serviceConfig.KeepAlive = true;
    };
  };

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;
  programs.nix-index.enable = true;

  services.emacs = {
    enable = false;
    # TODO: Find a way to shorten this path
    package = emacs;
  };

  home-manager.users.bastienriviere = {
    programs.emacs = {
      enable = true;
      package = emacs;
    };

    home.file = {
      ".doom.d" = {
        source = ../../doom.d;
        recursive = true;
        onChange = "~/.emacs.d/bin/doom sync";
      };
      # Not working as planned
      # ".emacs.d" = {
      #   source = doom-emacs;
      #   recursive = true;
      #   onChange = "~/.emacs.d/bin/doom upgrade";
      # };
    };

    home.packages = let
      nvimConfig = pkgs.neovimUtils.makeNeovimConfig {
        withPython3 = true;
        withNodeJs = true;
        viAlias = true;
        vimAlias = true;
      };
      nvim = pkgs.wrapNeovimUnstable pkgs.neovim-nightly (nvimConfig // {
        wrapperArgs = (lib.escapeShellArgs nvimConfig.wrapperArgs);
        wrapRc = false;
      });
    in [
      nvim
      pkgs.tree-sitter

      # Tools
      pkgs.age
      pkgs.bat
      pkgs.dogdns
      pkgs.exa
      pkgs.github-cli

      # Nix
      pkgs.nixfmt
      pkgs.nix-prefetch-scripts
      pkgs.nixpkgs-review

      # Common Lisp
      pkgs.sbcl

      # Clojure
      # FIXME: pkgs.babashka
      pkgs.boot
      pkgs.clojure
      # FIXME: pkgs.clojure-lsp
      pkgs.leiningen
    ];
    home.stateVersion = "21.03";

    programs.direnv = { enable = true; };

    programs.fish = { enable = false; };

    programs.fzf = { enable = true; };

    programs.zsh = {
      # TODO: write configuration here
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;

      autocd = true;
      defaultKeymap = "viins";
      history = { expireDuplicatesFirst = true; };

      initExtra = builtins.readFile ../zshrc;

      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
        {
          name = "history-substring-search";
          src = "${pkgs.zsh-history-substring-search}/share/zsh/site-functions";
        }
      ];
    };
  };

  users.users.bastienriviere = {
    name = "bastienriviere";
    home = "/Users/bastienriviere";
  };

  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      QuitMenuItem = true;
      _FXShowPosixPathInTitle = true;
    };
    NSGlobalDomain.AppleFontSmoothing =
      1; # my display doesn't have high dpi so it looks like blurry when not enabled
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
