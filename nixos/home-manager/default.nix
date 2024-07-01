{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./programs
  ];

  home.username = "dchoi";
  home.homeDirectory = "/home/dchoi";

  home.stateVersion = "24.05";
}
