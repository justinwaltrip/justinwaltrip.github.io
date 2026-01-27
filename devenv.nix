{ pkgs, lib, config, inputs, ... }:

{
  enterShell = ''
    clear
  '';
  packages = with pkgs; [
    pre-commit
  ];
  scripts.check.exec = ''
    pre-commit run --all-files
  '';
}
