# This is a custom Xanmod-based Kernel for my own uses
#  I was inspired to create this after running into Nixpkgs deprecating mainline kernels
#  before ZFS would release stable updates
#  I had wanted to produce my own anyway, and this inspired me to start
#
# Inspiration:
# Xanmod (the base) - https://xanmod.org/
# Raf - https://github.com/NotAShelf/nyx/blob/main/hosts/enyo/kernel/packages/xanmod.nix
# Clear Linux - RIP to Clear, though they did provide some insight into optimizations I chose
#
# WARNING:
# These are all **x86-64v3** builds by default
#
# I only have that architecture among my systems, so it works for me,
#  check your CPUs before using this as-is
{pkgs}: let
  # Import modular components
  profileConfigs = import ./profiles.nix;
  versions = import ./versions.nix;
  buildCustomKernel = import ./builder.nix {
    inherit pkgs profileConfigs;
  };

  # Helper to build a specific version with a profile
  buildVersion = {
    versionKey ? "6.17.11",
    profile,
    customSuffix,
    x86version ? "3", # Default to v3, but allow override
  }: let
    versionInfo = versions.${versionKey};
  in
    buildCustomKernel {
      inherit (versionInfo) version hash;
      inherit profile customSuffix x86version;
    };
in {
  x86_64-linux = {
    jet1_latest = buildVersion {
      profile = "server";
      customSuffix = "jet1";
    };

    jet2_latest = buildVersion {
      profile = "balanced";
      customSuffix = "jet2";
    };

    jet3_latest = buildVersion {
      profile = "performance";
      customSuffix = "jet3";
    };
  };
}
