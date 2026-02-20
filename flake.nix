{
  description = "v-server configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, agenix, ... }: {
    nixosConfigurations.v-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./config/stalwart.nix
        ./config/system.nix
        ./config/hardware.nix
        ./config/networking.nix
        ./config/nginx.nix
        ./config/thomascreagh.com.nix
        agenix.nixosModules.default
      ];
    };

    packages.x86_64-linux.agenix = agenix.packages.x86_64-linux.default;
  };
}
