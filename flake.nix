{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
  };
  outputs =
    {
      self,
      nixpkgs,
      systems,
      ...
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      packages = eachSystem (
        system:
        let
          pkgs = import nixpkgs { system = "${system}"; };
        in
        {
          default = self.packages.${system}.ttf2psf.nightly;
          ttf2psf = {
            nightly = pkgs.callPackage ./default.nix { };
          };
        }
      );
      overlays.ttf2psf = (self: super: { ttf2psf = self.packages.x86_64-linux.default; });
      devShells = eachSystem (
        system:
        let
          pkgs = import nixpkgs { system = "${system}"; };
        in
        {
          default = pkgs.mkShellNoCC { packages = with pkgs; [ ]; };
        }
      );
    };
}
