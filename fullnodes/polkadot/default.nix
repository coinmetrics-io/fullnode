{ nixpkgs, version }:
rec {
  package = with nixpkgs; rustPlatform.buildRustPackage {
    pname = "polkadot";
    inherit version;
    cargoSha256 = {
      "0.8.26" = "0mjkiq6kih5vbmbmr3nmzw4zynha93lsqwbvams73871124mj7rc";
    }.${version} or (builtins.trace "Polkadot fullnode: using dummy cargo SHA256" "0000000000000000000000000000000000000000000000000000");
    src = builtins.fetchGit {
      url = "https://github.com/paritytech/polkadot.git";
      ref = "refs/tags/v${version}";
    };

    nativeBuildInputs = [ clang ];
    buildInputs = [ pkgconfig openssl ];
    LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
    PROTOC = "${protobuf}/bin/protoc";

    # building WASM binary is complicated
    # see https://github.com/NixOS/nixpkgs/pull/98785
    # and https://gitlab.w3f.tech/florian/w3fpkgs/-/blob/master/pkgs/parity-polkadot/default.nix
    BUILD_DUMMY_WASM_BINARY = 1;

    runVend = true;
    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/polkadot" ];
      User = "1000:1000";
    };
  };
}
