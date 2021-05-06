{ lib, stdenv , fetchFromGitHub
, pkg-config, autoreconfHook
, db5, openssl, boost, zlib, miniupnpc, libevent
, protobuf, util-linux, qt4, qrencode
, withGui }:

with lib;
stdenv.mkDerivation rec {
  name = "dogecoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "1.14.3";

  src = fetchFromGitHub {
    owner = "dogecoin";
    repo = "dogecoin";
    rev = "v${version}";
    sha256 = "15yjzyvgic96pybadfk37zb032xvra0v37iphbnh15dci2fd934j";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook util-linux ];
  buildInputs = [ openssl db5 openssl protobuf boost zlib miniupnpc libevent ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [ "--with-incompatible-bdb"
                     "--with-boost-libdir=${boost.out}/lib" ]
                     ++ optionals withGui [ "--with-gui" ];

  meta = {
    description = "Wow, such coin, much shiba, very rich";
    longDescription = ''
      Dogecoin is a decentralized, peer-to-peer digital currency that
      enables you to easily send money online. Think of it as "the
      internet currency."
      It is named after a famous Internet meme, the "Doge" - a Shiba Inu dog.
    '';
    homepage = "http://www.dogecoin.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ edwtjo offline ];
    platforms = platforms.linux;
  };
}
