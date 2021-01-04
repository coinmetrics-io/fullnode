{ nixpkgs, version }:
rec {
  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "monero";
    inherit version;

    src = nixpkgs.fetchgit {
      url = "https://github.com/monero-project/monero.git";
      rev = "refs/tags/v${version}";
      fetchSubmodules = true;
      sha256 = {
        "0.17.1.5" = "0yy9n2qng02j314h8fh5n0mcy6vpdks0yk4d8ifn8hj03f3g2c8b";
        "0.17.1.6" = "0b6zyr3mzqvcxf48i2g45gr649x6nhppik5598jsvg0z7i2hxb9q";
        "0.17.1.7" = "1fdw4i4rw87yz3hz4yc1gdw0gr2mmf9038xaw2l4rrk5y50phjp4";
        "0.17.1.8" = "10blazbk1602slx3wrmw4jfgkdry55iclrhm5drdficc5v3h735g";
      }.${version} or (builtins.trace "Monero fullnode: using dummy SHA256" "0000000000000000000000000000000000000000000000000000");
    };

    nativeBuildInputs = [ pkgconfig cmake ];

    buildInputs = [ boost openssl zeromq libsodium ];

    configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
      "--disable-shared"
      "--disable-wallet"
      "--disable-bench"
      "--disable-tests"
    ];

    doCheck = false;

    enableParallelBuilding = true;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/monerod" ];
      User = "1000:1000";
    };
  };
}
