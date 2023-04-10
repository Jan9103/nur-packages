{ lib
, fetchFromGitHub
, rustPlatform
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "blitzkrieg-rs";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "adhamsalama";
    repo = "blitzkrieg";
    rev = "v${version}";
    sha256 = lib.fakeHash;
  };

  cargoSha256 = lib.fakeHash;

  cargoPatches = [];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    HOME=$TMPDIR cargo test
    runHook postCheck
  '';

  meta = with lib; {
    description = "A multithreaded HTTP web server written from scratch in Rust.";
    homepage = "https://github.com/adhamsalama/blitzkrieg";
    license = licenses.MIT;  # written in Cargo.toml
    mainProgram = pname;
    platforms = platforms.linux;
  };

  passthru = {
    updateScript = nix-update-script { };
  };
}
