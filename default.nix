# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

{
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  inochi-session = pkgs.callPackage ./pkgs/inochi-session { };
  mocword = pkgs.callPackage ./pkgs/mocword { };
  mocword-with-data = pkgs.callPackage ./pkgs/mocword/with_data.nix { };
  nushell = pkgs.callPackage ./pkgs/nushell { };
  nushell-custom = pkgs.callPackage ./pkgs/nushell-custom { };
  nushell-preview = pkgs.callPackage ./pkgs/nushell-preview { };
  ruson = pkgs.callPackage ./pkgs/ruson { };
  streampager = pkgs.callPackage ./pkgs/streampager { };
}
