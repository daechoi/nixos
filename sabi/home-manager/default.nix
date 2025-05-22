{
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./programs
  ];
  home = {
    username = "dchoi";
    homeDirectory = lib.mkForce "/Users/dchoi";
    stateVersion = "24.05";
  };
}
