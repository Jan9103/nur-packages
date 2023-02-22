{appimageTools, pkgs, fetchurl}:

appimageTools.wrapType2 {
  name = "inochi-session";
  src = fetchurl {
    url = "https://github.com/Inochi2D/inochi-session/releases/download/v0.5.4/inochi-session-x86_64.AppImage";
    sha256 = "sha256-d0ACJzBc1dCsfFl/wzhANi5qQyBrwXD9QWY+Ie7LZ+Q=";
  };
  extraPkgs = pkgs: [];
}
