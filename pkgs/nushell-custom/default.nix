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
  version = "0.77.2-custom";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = "cb1eefd24ab632c5b43d4427b90ce04871f21a0a";
    sha256 = "sha256-E2iNDwLy+Vxz4T0T43zAjoMBuYJd6wNH4wfWc2CD9C0=";
  };

  cargoSha256 = "sha256-cgn0SbvpRkn88z0oCOIoNRG2KJc3vmnvtZg3dMF2axY=";

  cargoPatches = [
    ./better-cp-progress-bar.patch
    ./expand-tilde-in-backticks.patch
    ./fix-empty-dict-explore-error.patch
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
