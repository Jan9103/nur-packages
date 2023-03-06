{ lib
, fetchFromGitHub
, rustPlatform
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "mocword";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "high-moctane";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aDwqj9myaGRkAcVkC2upHtQT+uq/ZRk72teWz6egCsc=";
  };

  cargoSha256 = "sha256-3NRtQ0AeGe1mpzXWoqN86POOv9uQBu9VWk9qQ5p/sWI=";

  cargoPatches = [
    ./cargo-lock.patch  # adds a cargo.lock
  ];

  nativeBuildInputs = [ ];

  buildInputs = [ ];

  doCheck = false;  # it has no tests

  meta = with lib; {
    description = "Predict next words";
    homepage = "https://github.com/high-moctane/mocword";
    license = licenses.mit;
    mainProgram = "mocword";
    platforms = platforms.linux;
  };

  passthru = {
    updateScript = nix-update-script { };
  };
}
