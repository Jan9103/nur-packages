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
    rev = "0b9fc4ff3a502135be928fc09bfc9412c87fc5a6";
    sha256 = "sha256-pnRzCEdk+bochFsUug4YPlwfrHGIFyf8AgLS82d33Bw=";
  };

  cargoSha256 = "sha256-OEoMF9yUxKLA2TmW5dQXOMybpwEBmgWTSL8xXqS7R5o=";

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
