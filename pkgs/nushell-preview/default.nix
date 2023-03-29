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
  pname = "nushell-preview";
  version = "0.77.2-preview";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = "393717dbb42943d1238188e07d80610f9a7b69c3";
    sha256 = "sha256-vl8oUd1Mime7On7xzKewnSTxXhpg3YVyCa+FcyQr2Zo=";
  };

  cargoSha256 = "sha256-D6md6pDJSE5Zu7+potknKZSgv/pka3gPjsEmCP5NJi4=";

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
