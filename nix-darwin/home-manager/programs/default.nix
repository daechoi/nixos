{
  config,
  pkgs,
  inputs,
  ...
}: let
  neovimconfig = import ../nixvim/config;
  nvim = inputs.nixvim.legacyPackages.x86_64-darwin.makeNixvimWithModule {
    inherit pkgs;
    module = neovimconfig;
  };
in {
  home.packages = with pkgs; [
    nvim

    direnv
    #dev
    just
    go
    rustup

    iperf
  ];

  programs = {
    home-manager.enable = true;
  };

  # Fonts
}
