{ lib
, fetchFromGitHub
, rustPlatform
, openssl
, zstd
, pkg-config
, python3
, xorg
, testers
, nushell
, nix-update-script
}:

rustPlatform.buildRustPackage {
  pname = "nushell-unstable";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = "0.79.0";
    sha256 = "sha256-vnOTSXTgFxNTI4msgMQ/5E27VUKPj6nBIqPWLUeXAr4=";
  };

  cargoSha256 = "sha256-smnSTlNeSC2mEibOxsrToG6M78KKv+DaR+csKISb8wo=";

  cargoPatches = [
    ./remove-let-else.patch
  ];

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ openssl zstd xorg.libX11 ];

  buildFeatures = [ "default" ];

  doCheck = false;  # the tests require a newer rustc version than available

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    HOME=$TMPDIR cargo test
    runHook postCheck
  '';

  meta = with lib; {
    description = "A modern shell written in Rust";
    homepage = "https://www.nushell.sh/";
    license = licenses.mit;
    #maintainers = with maintainers; [ Br1ght0ne johntitor marsam ];
    mainProgram = "nu";
    platforms = platforms.linux;
  };

  passthru = {
    shellPath = "/bin/nu";
    tests.version = testers.testVersion {
      package = nushell;
    };
    updateScript = nix-update-script { };
  };
}
