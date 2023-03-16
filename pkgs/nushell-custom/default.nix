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
  pname = "nushell-custom";
  version = "0.77.1-custom";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = "e672689a762b0c640acb6922fa7cf8158f908025";
    sha256 = "sha256-KpHJ5QXgIogiuElij6M5h85kMBS8ucmxB+8dVALjbRI=";
  };

  cargoSha256 = "sha256-uSwY/aG5vw2xeDnVIQxPIsq5qCa0R01QLiZ/GH6D3wM=";

  cargoPatches = [
    ./better-cp-progress-bar.patch
    ./better-else-if-error-message.patch
    ./enable-error-reporting-from-vt.patch
    ./exitcode-0-for-help.patch
    ./fix-ls-symlink.patch
    ./revert-eager-eval-in-subexp.patch
  ];

  nativeBuildInputs = [ pkg-config python3 ];

  buildInputs = [ openssl zstd xorg.libX11 ];

  buildFeatures = [ "default" ];

  doCheck = true;

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
