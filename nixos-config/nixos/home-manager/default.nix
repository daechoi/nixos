{inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./programs
  ];

  home = {
    username = "dchoi";
    homeDirectory = "/home/dchoi";
    stateVersion = "24.05";
  };
}
