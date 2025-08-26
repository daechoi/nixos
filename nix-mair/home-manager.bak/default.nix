{
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./programs
  ];
  home = {
    username = "dchoi";
    homeDirectory = lib.mkForce "/Users/dchoi";
    stateVersion = "24.05";
  };
}
#       homeDirectory = lib.mkForce "/Users/dchoi";

