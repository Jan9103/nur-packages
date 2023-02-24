{ stdenv
, lib
, fetchFromGitHub
, rustPlatform
, openssl
, zstd
, pkg-config
, python3
, xorg
, withExtraFeatures ? true
, testers
, nushell
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "nushell";
  version = "0.76.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-dGsnbKsg0nQFFXZDRDei2uGhGWEQSeSHGpXJp+8QUC8=";
  };

  cargoSha256 = "sha256-GsnfLijPhnEbFHRmyqEfrFVWkFQghC7ExLD8dQidyh4=";

  
  cargoPatches = [
    #./zstd-pkg-config.patch
    # - update dependencies
    # - enable pkg-config feature of zstd ( ./zstd-pkg-config.patch )
    ./cargo-dependencies.patch
  ];

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals (withExtraFeatures && stdenv.isLinux) [ python3 ];

  buildInputs = [ openssl zstd ]
    ++ lib.optionals (withExtraFeatures && stdenv.isLinux) [ xorg.libX11 ];

  buildFeatures = lib.optional withExtraFeatures "extra";

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
