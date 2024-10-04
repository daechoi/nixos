{
  config,
  pkgs,
  inputs,
  ...
}: let
  nixvimconfig = import ../nixvim/config;
  nvim = inputs.nixvim.legacyPackages.x86_64-darwin.makeNixvimWithModule {
    inherit pkgs;
    module = nixvimconfig;
  };
in {
  home.packages = with pkgs; [
    direnv
    nvim
    #    rust-analyzer

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
