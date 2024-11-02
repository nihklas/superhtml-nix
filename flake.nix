{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    zig-overlay,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        overlays = [
          (final: prev: {
            zigpkgs = zig-overlay.packages.${prev.system}."0.13.0";
          })
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        version = "v0.5.3";
      in
        with pkgs; {
          packages.default = stdenv.mkDerivation {
            name = "superhtml";
            version = version;
            src = fetchTarball {
              url = "https://github.com/kristoff-it/superhtml/archive/refs/tags/${version}.tar.gz";
              sha256 = "0z4qz9d5ap02x5ssaw7lh2da5g9qsapydy5dmc7aqjp79r5wgvmc";
            };
            buildInputs = [zig];
            preBuild = "export HOME=$TMPDIR";
            installPhase = ''
              runHook preInstall
              zig build --prefix $out install
              runHook postInstall
            '';
          };
        }
    );
}
