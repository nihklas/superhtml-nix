{
  inputs = {
    zig2nix.url = "github:Cloudef/zig2nix";
  };

  outputs = {
    self,
    zig2nix,
  }: let
    outputs =
      zig2nix.inputs.flake-utils.lib.eachDefaultSystem
      (
        system: let
          pkgs = env.pkgs;
          env = zig2nix.outputs.zig-env.${system} {};
          commit = "e6eba40bf54dd94d842154be0389c53a37be8dc8";
          srcWithLock = pkgs.stdenv.mkDerivation {
            name = "src-with-lock";
            src = fetchGit {
              url = "https://github.com/kristoff-it/superhtml.git";
              rev = commit;
              ref = "main";
              shallow = true;
            };
            installPhase = ''
              mkdir -p $out
              cp -r $src/* $out
              cp ${self}/build.zig.zon2json-lock $out/build.zig.zon2json-lock
            '';
          };
          bin = env.package {
            name = "superhtml";
            src = env.pkgs.lib.cleanSource srcWithLock;
            version = commit;
          };
        in {
          packages.default = bin;
          apps.update = env.app [env.zon2json-lock pkgs.wget pkgs.git pkgs.gnused] "./update.sh";
        }
      );
  in
    outputs
    // {
      overlays.default = final: prev: {
        superhtml = outputs.packages.${prev.system}.default;
      };
    };
}
