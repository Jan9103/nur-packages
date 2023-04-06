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
    rev = "bcdb9bf5b4dafad570260ecdaeabf4edbbef363c";
    sha256 = "sha256-JQZPZg50OvVEWFoYNQwXqcd8nZ7Jmt9YDpY/wzkPkLo=";
  };

  cargoSha256 = "sha256-LqJo/ZyH19+YYiOU29euC2qRhpUzAA9Gj1KnDY1qPk4=";

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
