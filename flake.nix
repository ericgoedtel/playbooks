{
  description = "NixOS Infrastructure for Home Lab Equipment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    disko,
    ...
  } @ inputs: {
    nixosConfigurations.pilothouse = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        disko.nixosModules.disko
        ./nixos/hosts/pilothouse/configuration.nix
      ];
    };

    devShells.x86_64-linux.default = let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      pkgs.mkShell {
        packages = with pkgs; [
          pre-commit
          nixpkgs-fmt
          statix
          deadnix
          alejandra
        ];

        shellHook = ''
          # If not running in direnv and shell is interactive, launch zsh
          if [ -z "$DIRENV_DIR" ] && [ -n "$PS1" ] && [ -x "$(command -v zsh)" ]; then
            exec zsh
          fi
        '';
      };
  };
}
