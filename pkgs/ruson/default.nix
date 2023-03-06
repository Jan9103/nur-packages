{ lib
, fetchFromGitHub
, rustPlatform
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "ruson";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "lycuid";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Y/Bw7HDvAx3lAsv4HeTPuFhew6VbxbEv/2+HDC8XRV0=";
  };

  cargoSha256 = "sha256-T4G0zmIkelN82hmjPR0k3NVD+4xY3Q7L+1aab1kiLU8=";

  cargoPatches = [
    ./cargo-lock.patch  # add cargo.lock
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    HOME=$TMPDIR cargo test
    runHook postCheck
  '';

  meta = with lib; {
    description = "Command line json text parsing and processing utility. parsing json compliant with rfc8259";
    homepage = "https://github.com/lycuid/ruson";
    license = licenses.gpl3;
    mainProgram = pname;
    platforms = platforms.linux;
  };

  passthru = {
    updateScript = nix-update-script { };
  };
}
