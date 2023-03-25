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
    rev = "ad4450f9e8217adcc79809dc15b18430309eabc6";
    sha256 = "sha256-GXMW+X0Wjk5mMJxzcw5mpffO/u6eZBlq9QTdKHS6nG0=";
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
