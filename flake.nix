{
  description = "Michael's Custom Linux Kernels";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  };

  outputs = {nixpkgs, ...}: let
    # I specifically allow unfree so that kernel modules can work, like nvidia
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config = {allowUnfree = true;};
    };
  in {
    packages = import ./kernel/xanmod-jet.nix {
      inherit pkgs;
    };
  };
}
