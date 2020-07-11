
{
  # TODO: rename git repot to 'flake-wayland-apps'
  description = "wayland-apps";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    master = { url = "github:nixos/nixpkgs/master"; }; # (for nixFlakes)
  };

  outputs = inputs:
    let
      metadata = builtins.fromJSON (builtins.readFile ./latest.json);

      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);
      forAllSystems = genAttrs [ "x86_64-linux" "i686-linux" "aarch64-linux" ];

      overlay = import ./default.nix;
      
      pkgsFor = pkgs: system: includeOverlay:
        import pkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = if includeOverlay then [ overlay ] else [];
        };
    in
    rec {
      devShell = forAllSystems (system:
        let
          nixpkgs_ = (pkgsFor inputs.nixpkgs system false);
          master_ = (pkgsFor inputs.master system false);
        in
          nixpkgs_.mkShell {
            nativeBuildInputs = with nixpkgs_; [
              master_.nixFlakes
              bash
              cacert
              cachix
              curl
              git
              jq
              mercurial
              nix
              nix-build-uncached
              nix-prefetch
              openssh
              ripgrep
            ];
          }
      );

      packages = forAllSystems (system:
        (pkgsFor inputs.nixpkgs system true).
          waylandPkgs
      );

      defaultPackage = forAllSystems (system:
        let
          nixpkgs_ = (pkgsFor inputs.nixpkgs system true);
          attrValues = inputs.nixpkgs.lib.attrValues;
        in
          nixpkgs_.symlinkJoin {
            name = "nixpkgs-wayland";
            paths = attrValues nixpkgs_.waylandPkgs;
          }
      );
    };
}
