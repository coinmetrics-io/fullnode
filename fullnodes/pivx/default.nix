{ nixpkgs, version }:
rec {
  src = builtins.fetchGit {
    url = "https://github.com/PIVX-Project/PIVX.git";
    ref = "refs/tags/v${version}";
  };

  g43 = builtins.compareVersions version "4.3.0" >= 0;

  package = with nixpkgs; stdenv.mkDerivation rec {
    pname = "pivx";
    inherit version src;

    nativeBuildInputs = [ pkgconfig autoreconfHook ];

    buildInputs = [ boost libevent openssl gmp db48 ] ++ lib.optional g43 libsodium;

    preConfigure = if g43 then ''
      sed -ie 's/: cargo-build/:/' src/Makefile.am
    '' else null;

    configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
      "--disable-shared"
      # "--disable-wallet" # not implemented in pivx
      "--disable-bench"
      "--disable-tests"
      "--disable-online-rust"
    ];

    makeFlags = lib.optional g43 "LIBRUSTZCASH=${librustzcash}/lib/librustzcash.a";

    doCheck = false;

    enableParallelBuilding = true;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/pivxd" ];
      User = "1000:1000";
    };
  };

  librustzcash = nixpkgs.rustPlatform.buildRustPackage rec {
    pname = "pivx-librustzcash";
    inherit version src;

    cargoSha256 = {
      "4.3.0" = "0gyglcp47fh4whpvrkb18gf7ds1fixqy3qldjqshx7gnqycjjhnm";
      "5.0.0" = "1hgxqi17nchdb193vpnlz6aj5sq7lr06izavbrv0znf3cy3lyahx";
    }.${version} or (builtins.trace "PIVX librustzcash: using dummy cargo SHA256" "0000000000000000000000000000000000000000000000000000");

    runVend = true;
    doCheck = false;
  };
}
