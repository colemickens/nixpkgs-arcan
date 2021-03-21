{
  description = "nixpkgs-wayland";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    unstableSmall = { url = "github:nixos/nixpkgs/nixos-unstable-small"; };
    cachix = { url = "github:nixos/nixpkgs/nixos-20.09"; };
  };

  outputs = inputs:
    let
      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = genAttrs supportedSystems;
      pkgsFor = pkgs: system: overlays:
        import pkgs {
          inherit system overlays;
          config.allowUnfree = true;
        };
      pkgs_ = genAttrs (builtins.attrNames inputs) (inp: genAttrs supportedSystems (sys: pkgsFor inputs."${inp}" sys []));
      fullPkgs_ = genAttrs (builtins.attrNames inputs) (inp: genAttrs supportedSystems (sys: pkgsFor inputs."${inp}" sys [inputs.self.overlay]));
    in
    rec {
      devShell = forAllSystems (system:
        fullPkgs_.nixpkgs.${system}.mkShell {
          nativeBuildInputs = []
            ++ (with pkgs_.cachix.${system}; [ cachix ])
            ++ (with fullPkgs_.nixpkgs.${system}; [
                nixUnstable nix-prefetch nix-build-uncached
                bash cacert curl git jq mercurial openssh ripgrep parallel
            ]); });

      defaultPackage = packagesBundle;

      packages = forAllSystems (system:
        fullPkgs_.nixpkgs.${system}.arcanPkgs);

      smallPackages = forAllSystems (system:
        fullPkgs_.unstableSmall.${system}.arcanPkgs);

      packagesBundle = forAllSystems (system: with fullPkgs_.nixpkgs.${system};
          linkFarmFromDrvs "wayland-packages-unstable"
            (builtins.attrValues arcanPkgs));

      smallPackagesBundle = forAllSystems (system: with fullPkgs_.unstableSmall.${system};
          linkFarmFromDrvs "wayland-packages-unstable-small"
            (builtins.attrValues arcanPkgs));

      overlay = final: prev:
        let
          arcanPkgs = rec {
            cage             = prev.callPackage ./pkgs/cage { wlroots = prev.wlroots; };
          };
        in
          arcanPkgs // { inherit arcanPkgs; };
    };
}
