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
    rev = "06996d8c7f0205d1aedb36387a049a066599f46e";
    sha256 = "sha256-exAeXGl/tUgsfEuCKtgL1hGovktRY3eFpthM5A1CQug=";
  };

  cargoSha256 = "sha256-1j2TRs834N5fIND1t7t/WNcTCeErlsqco9RDuUdSF0Y=";

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
