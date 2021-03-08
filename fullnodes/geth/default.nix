{ nixpkgs, version }:
rec {
  package = with nixpkgs; buildGoModule {
    pname = "geth";
    inherit version;

    vendorSha256 = {
      "1.9.19" = "1744df059bjksvih4653nnvb4kb1xvzdhypd0nnz36m1wrihqssv";
      "1.9.20" = "1744df059bjksvih4653nnvb4kb1xvzdhypd0nnz36m1wrihqssv";
      "1.9.21" = "155hmny3543h02ryn1nnlpmvs0qvhd0lb66vmkhw5351m6gkbx7x";
      "1.9.22" = "1qbg44cryiv9kvcak6qjrbmkc9bxyk5fybj62vdkskqfjvv86068";
      "1.9.23" = "1qbg44cryiv9kvcak6qjrbmkc9bxyk5fybj62vdkskqfjvv86068";
      "1.9.24" = "1qbg44cryiv9kvcak6qjrbmkc9bxyk5fybj62vdkskqfjvv86068";
      "1.9.25" = "08wgah8gxb5bscm5ca6zkfgssnmw2y2l6k9gfw7gbxyflsx74lya";
      "1.10.0" = "186zyqmvj39d3s2bgrah0nw4pcqwswvf7wrzx2krbm34k6z8w30f";
    }.${version} or (builtins.trace "Geth fullnode: using dummy vendor SHA256" "0000000000000000000000000000000000000000000000000000");

    src = builtins.fetchGit {
      url = "https://github.com/ethereum/go-ethereum.git";
      ref = "refs/tags/v${version}";
    };

    runVend = true;
    doCheck = false;
  };

  imageConfig = {
    config = {
      Entrypoint = [ "${package}/bin/geth" ];
      User = "1000:1000";
    };
  };
}
