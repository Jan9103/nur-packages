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
    rev = "2ec20286371f1d90a77fdd5d82818c6c5851f090";
    sha256 = "sha256-fxx34xTFan5DcKo/sxFq6JxObGFTs4myNM0WmL5hnl8=";
  };

  cargoSha256 = "sha256-G9WdFz7Zobd5Ad628hVMSWgNDw7g54omizt/gfvq6YI=";

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
