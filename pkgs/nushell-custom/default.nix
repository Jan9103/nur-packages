{ stdenv
, lib
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
  version = "0.77.0-custom";
  # https://github.com/nushell/nushell/pull/8410

  src = fetchFromGitHub {
    owner = "sholderbach";
    repo = "nushell";
    rev = "c000ea9db76e5b2ae0c8874dac37be1ffb29064e";
    sha256 = "sha256-Z4kiDk7OiSdQWnhdT+Kgb7lwQp1t/ne3wTANQH7TWOw=";
  };

  cargoSha256 = "sha256-cHmHi+nI6s3sZNb7YbT/L27yZwBfUz5fiWuNG4+7ec0=";

  cargoPatches = [
    ./better-cp-progress-bar.patch
    ./better-else-if-error-message.patch
    ./fix-ls-symlink.patch
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
