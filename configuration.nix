# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "broadcom-sta"
    ];

  networking = {
    hostName = "dex"; # Define your hostname.
    networkmanager = {
      enable = true; # Easiest to use and most distros use this by default.
      dns = "default"; # Use NetworkManager's built-in DNS functionality.kkjjj
      wifi.scanRandMacAddress = false;
      wifi.powersave = false;
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  environment.variables.EDITOR = "vim";

  # Enable the flakes feature and the accompanying new nix command line tool:
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Enable the X11 windowing system.

  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      xkb.options = "eurosign:e,caps:escape";
    };

    libinput.enable = true;

    openssh.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # Configure keymap in X11
  #
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).

  users.users.dchoi = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker"]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock = {
      text = "auth include login";
    };
    #    wrappers = {
    #      rootlesskit = {
    #        owner = "root";
    #        group = "root";
    #        capabilities = "cap_net_bind_services=+ep";
    #        source = "${pkgs.rootlesskit.out}/bin/rootlesskit";
    #      };
    #    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    curl

    sway
    wl-clipboard
    mako
    wofi
    waybar
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.

  programs = {
    nm-applet.enable = true;
    zsh.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    sway = {
      enable = true;
    };
  };

  # Fonts
  fonts.packages = with pkgs; [
    fira-code
    fira
    cooper-hewitt
    ibm-plex
    jetbrains-mono
    iosevka
    #bitmap
    spleen
    fira-code-symbols
    powerline-fonts
    (nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})
  ];

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
