{
  description = "daml-mode emacs package for nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils}: let

    pname = "daml-mode";

    daml-mode-recipe = { lib, emacs, trivialBuild, fetchFromGitHub, haskell-mode, lsp-mode }:
      trivialBuild {
        inherit pname;

        packageRequires = [ haskell-mode lsp-mode ];
            
        src = fetchFromGitHub {
          owner = "bartfailt";
          repo = "daml-mode";
          rev = "d08c10db34331dfe0adfbba22e4079adda8add25";
          sha256 = "sha256-IPjN115qwq4GcA0I344WPfvMkPJIHFcG/MQbq+XnA4c=";
        };

        sourceRoot = "source/lisp";

        meta = with lib; {
          homepage = "https://github.com/bartfailt/daml-mode";
          description = "Emacs mode for editing daml projects, based on haskell-mode.";
          license = licenses.gpl3;
          inherit (emacs.meta) platforms;
        };
      };    
  in
    {
      overlays = rec {
        default = daml-mode;
        daml-mode = final: prev: {
          daml-mode = prev.callPackage daml-mode-recipe {};
        };
      };
    } //
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages = {
          ${pname} = pkgs.emacsPackages.callPackage daml-mode-recipe {};
          default = self.packages.${system}.${pname};
        };
        # devShells.default = with pkgs; mkShell {};
      }
    ); 
}

