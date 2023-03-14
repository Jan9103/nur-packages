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
  pname = "nushell-custom";
  version = "0.77.0-custom";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nushell";
    rev = "fd09609b44b53d41ac7929e90708cdeba7bfb571";
    sha256 = "sha256-cffAxuM12wdd7IeLbKSpL6dpvpZVscA8nMOh3jFqY3E=";
  };

  cargoSha256 = "sha256-IcShdXmnjwZwWHvbumcnJ/BDkGRAZ/WkALl31WFquIk=";

  cargoPatches = [
    ./better-cp-progress-bar.patch
    ./better-else-if-error-message.patch
    ./fix-ls-symlink.patch
  ];

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
