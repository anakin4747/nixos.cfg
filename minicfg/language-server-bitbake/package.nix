{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  nodejs,
  unzip,
}:

let
  version = "2.10.0";

  vsixSrc = fetchurl {
    url = "https://github.com/yoctoproject/vscode-bitbake/releases/download/v${version}/yocto-bitbake-${version}.vsix";
    hash = "sha256-CTmc/RQW46B83V86S3Z/6jZw4SjnMmFSFvV22toMLY4=";
  };

  serverTgz = fetchurl {
    url = "https://github.com/yoctoproject/vscode-bitbake/releases/download/v${version}/language-server-bitbake-${version}.tgz";
    hash = "sha256-Qg3WzG/6OoH7ayIdLQ5/DnB92rKPKfsHJhqH7XL2rwo=";
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
