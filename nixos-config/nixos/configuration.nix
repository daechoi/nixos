{
  lib,
  pkgs,
  ...
}: {
  #silent boot
  #  disabledModules = ["system/boot/stage-2.nix" "system/boot/stage-1.nix" "system/etc/etc.nix"];

  imports = [
    #silent boot
    # ./silent-boot/stage-2-silent.nix
    #./silent-boot/stage-1-silent.nix
    # ./silent-boot/etc-silent.nix
    ./silent-boot/boot.nix

    #hardware optimization
    ./hardware-optimization/framework-specific.nix
    ./hardware-optimization/hardware-configuration.nix
    #	./hardware-optimization/video-acceleration.nix
    ./hardware-optimization/ssd.nix

    #audio
    ./audio/general.nix
    #	./audio/bluetooth.nix

    #networking
    ./networking/networks.nix

    #wayland
    ./wayland/general.nix
    ./wayland/window-manager.nix
    ./wayland/login-manager.nix
  ];

  hardware = {
    bluetooth.enable = true;
    bluetooth.settings.Input = {
      ClassicBondedOnly = false;
    };
  };
  fonts.packages = with pkgs; [
    fira-code
    fira
    cooper-hewitt
    ibm-plex
    jetbrains-mono
    iosevka
    meslo-lgs-nf
    #bitmap
    spleen
    fira-code-symbols
    powerline-fonts
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
  ];

  time.timeZone = "America/New_York";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.sessionVariables = {
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XCURSOR_SIZE = "24";
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "google-chrome"
    ];

  users.users.dchoi = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    acpi
    vim
    wget
    tmux
    freshfetch
    gcc
    google-chrome
  ];

  programs = {
    mtr.enable = true;
    zsh.enable = true;
    git.enable = true;
    firefox.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  services = {
    logind.lidSwitchExternalPower = "ignore";
    blueman.enable = true;
    openssh.enable = true;
    printing.enable = true;
    pipewire.enable = true;
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

        STOP_CHARGE_THRESH_BAT0 = "80";
        START_CHARGE_THRESH_BAT0 = "40";
      };
    };
  };

  system.copySystemConfiguration = true;
  system.stateVersion = "24.05";
}
