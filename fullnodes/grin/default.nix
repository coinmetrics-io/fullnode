{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "grin";
    inherit version;

    cargoSha256 = {
      "5.0.4" = "0afa34yyc7z3a54rhz43396vd0r62wjgql3z6rvmpnr927ch8qli";
      "5.1.0" = "12ciinv2136x8vr011v71ixlhixnrwifjfx36kkj1nblrrg0vawd";
    }.${version} or lib.fakeSha256;

    src = builtins.fetchGit {
      url = "https://github.com/mimblewimble/grin.git";
      ref = "refs/tags/v${version}";
    };

    nativeBuildInputs = [ llvmPackages_12.clang ];

    buildInputs = [ ncurses ];

    LIBCLANG_PATH = "${llvmPackages_12.libclang.lib}/lib";
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/grin" ];
      User = "1000:1000";
    };
  };
}
