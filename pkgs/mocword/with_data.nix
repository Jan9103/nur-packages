{ lib
, fetchFromGitHub
, fetchurl
, rustPlatform
, nix-update-script
, gzip
, makeWrapper
}:

rustPlatform.buildRustPackage rec {
  pname = "mocword-with-data";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "high-moctane";
    repo = "mocword";
    rev = "v${version}";
    sha256 = "sha256-aDwqj9myaGRkAcVkC2upHtQT+uq/ZRk72teWz6egCsc=";
  };

  assets = fetchurl {
    url = "https://github.com/high-moctane/mocword-data/releases/download/eng20200217/mocword.sqlite.gz";
    sha256 = "sha256-5tyCED6A7ujn96D+D7Yc7vKKG5ZpF798P7tCk3wqEEA=";
  };

  cargoSha256 = "sha256-ktRcOxW9NR7ewCSS4SDM+Gn9J6zLbAj4RQ6kRq6eFXg=";

  cargoPatches = [
    ./cargo-lock.patch  # adds a cargo.lock
  ];

  nativeBuildInputs = [ gzip makeWrapper ];

  buildInputs = [ ];

  doCheck = false;  # it has no tests

  meta = with lib; {
    description = "Predict next words (including the english dataset)";
    homepage = "https://github.com/high-moctane/mocword";
    license = licenses.mit;
    mainProgram = "mocword";
    platforms = platforms.linux;
  };

  postInstall = ''
    mkdir -p $out/assets
    gzip -dc ${assets} > $out/assets/mocword.sqlite

    wrapProgram "$out/bin/mocword" \
      --set MOCWORD_DATA "$out/assets/mocword.sqlite"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };
}
