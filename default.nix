{
  pkg-config,
  freetype,
  stdenv,
  ...
}:

let
  pname = "ttf2psf";
  version = "1.0.1";
  src = ./.;
in
stdenv.mkDerivation {
  inherit pname version src;
  nativeBuildInputs = [
    pkg-config
    freetype
  ];
  installPhase = ''
  runHook preInstall

  mkdir -p $out/bin

  install -D -m 755 build/${pname} $out/bin/${pname}

  runHook postInstall
  '';
}
