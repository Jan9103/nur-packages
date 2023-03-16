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
    rev = "d74a260883cae9f31562c12a59cab160b9c36ed4";
    sha256 = "sha256-IhKsTsI5k3o+7moRAjNWIk6vDZEYIQx4RWzf3dxPN+w=";
  };

  cargoSha256 = "sha256-uSwY/aG5vw2xeDnVIQxPIsq5qCa0R01QLiZ/GH6D3wM=";

  cargoPatches = [
    ./better-cp-progress-bar.patch
    ./better-else-if-error-message.patch
    ./enable-error-reporting-from-vt.patch
    ./fix-empty-dict-explore-error.patch
    ./fix-ls-symlink.patch
    ./readd-get-i-flag.patch
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
