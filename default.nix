{ pkgs ? import <nixpkgs> {} }:
with pkgs;
pkgs.mkYarnPackage rec {
  name = "coc.nvim";
  src = ./.;
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  nativeBuildInputs = with nodePackages; [
    pkgs.git webpack webpack-cli
  ];

  installPhase = ''
    runHook preInstall
    yarn build
    (cd deps/${name} && webpack)
    mkdir -p "$out"
    mv deps/${name}/{autoload,bin,doc,plugin,build,data,package.json} "$out"
    runHook postInstall
  '';

  # Don't move "doc" to "share" otherwise it's not
  # accessible from vim.
  forceShare = ["man" "info"];

  distPhase = ":";
}
