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

rustPlatform.buildRustPackage rec {
  pname = "nushell";
  version = "0.78.0";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = version;
    sha256 = "sha256-fxx34xTFan5DcKo/sxFq6JxObGFTs4myNM0WmL5hnl8=";
  };

  cargoSha256 = "sha256-VqM6SAzYqwSSo3csjNCvcrZGwemtVHEGvh8gufouMeQ=";

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
