# This is copy-pasted from the pull request
#
# Will remove this when the pull request is merged.

{ stdenv, fetchFromGitHub, python, zip, makeWrapper, fetchurl, pkgconfig, git
, rsync, makeDesktopItem, runtimeShell, writeScript, runCommand
, nodejs, yarn, libsecret, xorg, ripgrep, electron }:

with stdenv.lib;

let
  system = stdenv.hostPlatform.system;

in stdenv.mkDerivation rec {
  pname = "code-server";
  version = "3.2.0";
  commit = "fd36a99a4c78669970ebc4eb05768293b657716f";

  src = fetchFromGitHub {
    owner = "cdr";
    repo = "code-server";
    rev = version;
    sha256 = "PX2WE4Wr4XUcJFw/FfKZ7PxueMXCOV/qQRGVqPThTqQ=";
    fetchSubmodules = true;
  };

  yarnCache = stdenv.mkDerivation {
    name = "${pname}-${version}-${system}-yarn-cache";
    inherit src;
    phases = ["unpackPhase" "buildPhase"];
    nativeBuildInputs = [ yarn git ];
    buildPhase = ''
      export HOME=$PWD
      # apply code-server patches as code-server has patched vscode yarn.lock
      yarn vscode:patch
      yarn config set yarn-offline-mirror $out
      find "$PWD" -name "yarn.lock" -printf "%h\n" | \
        xargs -I {} yarn install --cwd {} \
          --frozen-lockfile --ignore-scripts --ignore-platform --ignore-engines --no-progress --non-interactive
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";

    # to get hash values use nix-build -A code-server.yarnPrefetchCache --argstr system <system>
    outputHash = {
      x86_64-linux = "197v9660yqhvazalyhc87ciy6q2ii8xxi5bc5y96bck2w0d2y8if";
      aarch64-linux = "LiIvGuBismWSL2yV2DuKUWDjIzuIQU/VVxtiD4xJ+6Q=";
    }.${system} or (throw "Unsupported system ${system}");
  };

  # Extract the Node.js source code which is used to compile packages with
  # native bindings
  nodeSources = runCommand "node-sources" {} ''
    tar --no-same-owner --no-same-permissions -xf ${nodejs.src}
    mv node-* $out
  '';

  nativeBuildInputs = [ nodejs yarn python pkgconfig zip makeWrapper git rsync ];
  buildInputs = [ libsecret xorg.libX11 xorg.libxkbfile ];

  patchPhase = ''
    export HOME=$PWD
    # apply code-server vscode patches
    yarn vscode:patch
    # allow offline install for vscode
    substituteInPlace lib/vscode/build/npm/postinstall.js --replace '--ignore-optional' '--offline'
    # remove all built-in extensions, as these are 3rd party extensions that gets
    # downloaded from vscode marketplace
    echo '[]' > lib/vscode/build/builtInExtensions.json
    # patch commit as autodetection does not work if we don't have .git
    sed -i '/const commit/c\const commit = "${commit}";' ci/build.ts
  '';

  configurePhase = ''
    # set offline mirror to yarn cache we created in previous steps
    yarn --offline config set yarn-offline-mirror "${yarnCache}"
    npm config set nodedir "${nodeSources}"
  '';

  buildPhase = ''
    yarn install --frozen-lockfile --offline --no-progress --non-interactive
    # install without running scripts, for all required packages that needs patching
    for d in lib/vscode lib/vscode/build; do
      yarn install --cwd $d --frozen-lockfile --offline --no-progress --non-interactive --ignore-scripts
    done
    # put ripgrep binary into bin folder, so postinstall does not try to download it
    find -name vscode-ripgrep -type d \
      -execdir mkdir -p {}/bin \; \
      -execdir ln -s ${ripgrep}/bin/rg {}/bin/rg \;
    # patch shebangs of everything, also cached files, as otherwise postinstall
    # will not be able to find /usr/bin/env, as it does not exists in sandbox
    patchShebangs .
    (
      cd lib/vscode
      # rebuild binaries, we use npm here, as yarn does not provider alternative
      npm rebuild --update-binary
      # run postinstall scripts, which eventually do yarn install on all additional requirements
      yarn postinstall --offline --frozen-lockfile
    )
    yarn build
  '';

  installPhase = ''
    mkdir -p $out/libexec/code-server $out/bin
    cp -R -T build $out/libexec/code-server
    makeWrapper "${nodejs}/bin/node" "$out/bin/code-server" \
      --add-flags "$out/libexec/code-server/out/node/entry.js"
  '';

  passthru = {
    prefetchYarnCache = overrideDerivation yarnCache (d: {
      outputHash = "0000000000000000000000000000000000000000000000000000000000000000";
    });
  };

  meta = {
    description = ''
      Run VS Code on a remote server.
    '';
    longDescription = ''
      code-server is VS Code running on a remote server, accessible through the browser.
    '';
    homepage = "https://github.com/cdr/code-server";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];
    platforms = ["x86_64-linux"];
  };
}
