{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem
    (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
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
