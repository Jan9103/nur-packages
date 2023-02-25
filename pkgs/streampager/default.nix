{ lib
, fetchFromGitHub
, rustPlatform
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "streampager";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "markbt";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-S3di/BCDzVB95lo4w8xraJ77xR6g1+9bfQitMlHNqP0=";
  };

  cargoSha256 = "sha256-ZL+BWRnidwxNAIjTItS55kpOLS0fDgVSRJXpitlylvo=";

  #cargoPatches = [];

  nativeBuildInputs = [];

  buildInputs = [];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    echo "Running cargo test"
    HOME=$TMPDIR cargo test
    runHook postCheck
  '';

  meta = with lib; {
    description = "A pager for command output or large files.";
    homepage = "https://github.com/markbt/streampager";
    license = licenses.mit;
    mainProgram = "sp";  # + "spp"
    platforms = platforms.linux;
  };

  passthru = {
    updateScript = nix-update-script { };
  };
}
