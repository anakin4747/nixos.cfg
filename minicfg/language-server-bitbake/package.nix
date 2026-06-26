{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  nodejs,
  unzip,
}:

let
  version = "2.9.0";

  vsixSrc = fetchurl {
    url = "https://github.com/yoctoproject/vscode-bitbake/releases/download/v${version}/yocto-bitbake-${version}.vsix";
    hash = "sha256-7Mawp+mEkjniQmKe1fZPcLibcZ6d9xIHJh243LIzU1w=";
  };

  serverTgz = fetchurl {
    url = "https://github.com/yoctoproject/vscode-bitbake/releases/download/v${version}/language-server-bitbake-${version}.tgz";
    hash = "sha256-pRPP3rDrEo5sh0tGmTh9BDcTK6QZTWK4en60Zb55+jU=";
  };
in

stdenvNoCC.mkDerivation {
  pname = "language-server-bitbake";
  inherit version;

  nativeBuildInputs = [ makeWrapper unzip ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/language-server-bitbake $out/bin

    tar xf ${serverTgz}
    cp -r package/. $out/lib/language-server-bitbake/

    unzip -q ${vsixSrc} "extension/server/node_modules/*" -d vsix
    cp -r vsix/extension/server/node_modules $out/lib/language-server-bitbake/

    makeWrapper ${lib.getExe nodejs} $out/bin/language-server-bitbake \
      --add-flags "$out/lib/language-server-bitbake/out/server.js" \
      --set NODE_PATH "$out/lib/language-server-bitbake/node_modules"

    runHook postInstall
  '';

  meta = {
    description = "BitBake language server from the vscode-bitbake extension";
    homepage = "https://github.com/yoctoproject/vscode-bitbake";
    license = lib.licenses.mit;
    mainProgram = "language-server-bitbake";
  };
}
