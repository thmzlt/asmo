{ pkgs ? import (fetchTarball https://github.com/nixos/nixpkgs/archive/b5dc07a4b471e6f651af3b13e4bd841b6b3ea6ed.tar.gz) {} }:

let
  elixir = pkgs.beam.packages.erlangR22.elixir_1_10;
in

pkgs.mkShell {
  buildInputs = [
    elixir
    (pkgs.terraform.withPlugins (p: [ p.aws ]))
  ];

  ERL_AFLAGS = "-kernel shell_history enabled";
}
