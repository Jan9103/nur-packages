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
  version = "preview";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = "d0a83fec693e50fbe38780aaec932f6b8cc8ed0a";
    sha256 = "sha256-R0Hi4zAUh5WIPTY/Sdyb0wpING+O7QLsVEGN2xUns4E=";
  };

  cargoSha256 = "sha256-AkLoA4ImkWvhVo8IiCTMM4pN9RpPD3FptmhS7JsjDNE=";

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
