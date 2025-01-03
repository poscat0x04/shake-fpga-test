{
  inputs = {
    nixpkgs.url = "git+ssh://git@github.com/NixOS/nixpkgs?ref=nixos-unstable&shallow=1";
    flake-utils.url = "git+ssh://git@github.com/poscat0x04/flake-utils?shallow=1";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    with flake-utils;
    eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in
      with pkgs;
      {
        devShell = shake-fpga-test-dev.envFunc { withHoogle = true; };
        defaultPackage = shake-fpga-test;
      }
    )
    // {
      overlay =
        self: super:
        let
          hpkgs = super.haskellPackages;
          shake-fpga-test = hpkgs.callCabal2nix "shake-fpga-test" ./. { };
        in
        with super;
        with haskell.lib;
        {
          inherit shake-fpga-test;
          shake-fpga-test-dev = addBuildTools shake-fpga-test [
            haskell-language-server
            cabal-install
          ];
        };
    };
}
