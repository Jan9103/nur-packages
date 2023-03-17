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
  version = "0.77.0-preview";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = "bb8949f2b27666cf77a8b7b4412b162fed61c49e";
    sha256 = "sha256-UeRZBB7PVjb+cdhV3zk8LyFVAJgAijombE7ad1ymrak=";
  };

  cargoSha256 = "sha256-H2itmGj4ZUmkTcJKqHCP+Q3sKxzmklwXSYAY5PSkuCg=";

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
