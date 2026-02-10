{ pkgs, lib, config, inputs, ... }:

{
  enterShell = ''
    git submodule update --init --recursive
    clear
  '';
  packages = with pkgs; [
    pre-commit
    hugo
  ];
  scripts = {
    check.exec = ''
      pre-commit run --all-files
    '';
    dev.exec = ''
      hugo server -D
    '';
  };
}
