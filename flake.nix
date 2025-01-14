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
          commit = "1fda813bd9dc108e962e018e6a327434767ad616";
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
          apps.update = env.app [env.zon2json-lock pkgs.wget pkgs.git] "./update.sh";
        }
      );
  in
    outputs
    // {
      overlays.default = final: prev: {
        zigscient = outputs.packages.${prev.system}.default;
      };
    };
}
