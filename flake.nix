{
  description = "Sentrixa's first-party Linux apps, packaged for Nix — individually installable per user (`nix profile install github:sentrixa/sentrixa-apps#<app>`), separate from the private sentrixa-os repo so any machine can reach them, not just ours.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in
    {
      packages.${system} = {
        stratavault = pkgs.callPackage ./pkgs/stratavault { };
        default = self.packages.${system}.stratavault;
      };
    };
}
