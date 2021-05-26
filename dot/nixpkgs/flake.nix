{
  description = "Example darwin system flake";

  inputs = {
    nix.url = "github:nixos/nix";
    nix.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, darwin, nixpkgs, home-manager, ... }@inputs:
  let
    configuration = { config, pkgs, ... }: {
      home-manager.useUserPackages = true;

      nix.package = inputs.nix.packages."x86_64-darwin".nix.overrideAttrs (attrs: {doCheck = false; doInstallCheck = false;});
      nix.useSandbox = "relaxed";
      nix.registry = {
        nixpkgs.flake = nixpkgs;
      };
      # nix.package = pkgs.nix;
      nixpkgs.overlays = [
        inputs.neovim-nightly.overlay
      ];

      services.nix-daemon.enable = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake ./modules/examples#darwinConfigurations.mac-fewlines.system \
    #       --override-input darwin .
    darwinConfigurations."Baba-Mac" = darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        ./machines/mac-fewlines.nix
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Baba-Mac".pkgs;
  };
}
