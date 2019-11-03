self: pkgs:
let
waylandPkgs = rec {
  # wlroots-related
  cage             = pkgs.callPackage ./pkgs/cage {};
  drm_info         = pkgs.callPackage ./pkgs/drm_info {};
  gebaar-libinput  = pkgs.callPackage ./pkgs/gebaar-libinput {};
  glpaper          = pkgs.callPackage ./pkgs/glpaper {};
  grim             = pkgs.callPackage ./pkgs/grim {};
  kanshi           = pkgs.callPackage ./pkgs/kanshi {};
  mako             = pkgs.callPackage ./pkgs/mako {};
  oguri            = pkgs.callPackage ./pkgs/oguri {};
  rootbar          = pkgs.callPackage ./pkgs/rootbar {};
  slurp            = pkgs.callPackage ./pkgs/slurp {};
  sway             = pkgs.callPackage ./pkgs/sway {};
  swaybg           = pkgs.callPackage ./pkgs/swaybg {};
  swayidle         = pkgs.callPackage ./pkgs/swayidle {};
  swaylock         = pkgs.callPackage ./pkgs/swaylock {};
  waybar           = pkgs.callPackage ./pkgs/waybar {};
  waybox           = pkgs.callPackage ./pkgs/waybox {};
  waypipe          = pkgs.callPackage ./pkgs/waypipe {};
  wdisplays        = pkgs.callPackage ./pkgs/wdisplays {};
  wev              = pkgs.callPackage ./pkgs/wev {};
  wf-recorder      = pkgs.callPackage ./pkgs/wf-recorder {};
  wlay             = pkgs.callPackage ./pkgs/wlay {};
  wlrobs           = pkgs.callPackage ./pkgs/wlrobs {};
  wl-clipboard     = pkgs.callPackage ./pkgs/wl-clipboard {};
  wldash           = pkgs.callPackage ./pkgs/wldash {};
  wlroots          = pkgs.callPackage ./pkgs/wlroots {};
  wlr-randr        = pkgs.callPackage ./pkgs/wlr-randr {};
  wofi             = pkgs.callPackage ./pkgs/wofi {};
  wtype            = pkgs.callPackage ./pkgs/wtype {};
  xdg-desktop-portal-wlr = pkgs.callPackage ./pkgs/xdg-desktop-portal-wlr {};

  # misc
  redshift-wayland = pkgs.callPackage ./pkgs/redshift-wayland {
    inherit (pkgs.python3Packages) python pygobject3 pyxdg wrapPython;
    geoclue = pkgs.geoclue2;
  };
  freerdp = pkgs.callPackage ./pkgs/freerdp {
    inherit (pkgs) libpulseaudio;
    inherit (pkgs.gst_all_1) gstreamer gst-plugins-base gst-plugins-good;
  };
  
  # i3 related
  i3status-rust    = pkgs.callPackage ./pkgs/i3status-rust {};
  
  # wayfire stuff
  wf-config        = pkgs.callPackage ./pkgs/wf-config {};
  wayfire          = pkgs.callPackage ./pkgs/wayfire { wlroots = wlroots-wf; };
  wlroots-wf       = pkgs.callPackage ./pkgs-temp/wlroots {};

  # bspwc/wltrunk stuff
  bspwc    = pkgs.callPackage ./pkgs/bspwc { wlroots = pkgs.wlroots; };
  wltrunk  = pkgs.callPackage ./pkgs/wltrunk { wlroots = pkgs.wlroots; };  
};
in
  waylandPkgs // { inherit waylandPkgs; }
