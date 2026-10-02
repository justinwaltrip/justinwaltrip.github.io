{ pkgs, lib, config, inputs, ... }:

{
  enterShell = ''
    git submodule update --init --recursive
    clear
  '';
  packages = with pkgs; [
    pre-commit
    hugo
    jq
    python3Packages.waybackpy
  ];
  scripts = {
    check.exec = ''
      pre-commit run --all-files
    '';
    archive-links.exec = ''
      ./scripts/archive-links.sh "$@"
    '';
    dev.exec = ''
      hugo server -D
    '';
  };
}
