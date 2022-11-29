# nix recipe for emacs' daml-mode

This repository contains a nix flake description for daml-mode package build based on [bartfailt's daml-mode repo](www.github.com/bartfailt/daml-mode).

# usage

## via overlay (recommended)

```nix
{
  inputs = {
    daml-mode.url = "githu:kczulko/daml-mode-emacs-nix";
    nixpkgs.url = "github:NixOS/nixpkgs"
  };

  outputs = { self, nixpkgs, daml-mode, ... }: 
    let
      pkgs = import nixpkgs {
        inherit system;
      };

      emacsWithPackages = 
        with pkgs; ((emacsPackagesFor emacs).overrideScope' daml-mode.overlays.default).emacsWithPackages;
      
    in {
      ...
      environment.systemPackages = [
        ...
        (emacsWithPackages (epkgs: [ epkgs.daml-mode ]))
        ...
      ]
      ...
    }
}
```

## via flake output

This option is not recommended since it's rather a dummy package (build with specific/hardcoded emacs version).

```nix
{
    inputs.daml-mode.url = "githu:kczulko/daml-mode-emacs-nix";
    outputs = { self, daml-mode, ... }: {
      ...
      environment.systemPackages = [
        ...
        (emacs.withPackages (epkgs: [
          ...
          daml-mode.packages.x86_64-linux.default
          ...
        ]))
        ...
      ]
      ...
    }
}

```

