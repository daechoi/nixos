{lib, inputs, ...}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./programs
  ];

  home = {
    username = "dae.choi";
    homeDirectory = lib.mkForce "/Users/dae.choi";
    stateVersion = "24.05";
  };
}
