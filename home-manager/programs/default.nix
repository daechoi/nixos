{
  config,
  pkgs,
  inputs,
  ...
}: let
  neovimconfig = import ../nixvim/config;
  nvim = inputs.nixvim.legacyPackages.x86_64-linux.makeNixvimWithModule {
    inherit pkgs;
    module = neovimconfig;
  };
in {
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them
    nvim

    # dev
    go
    rustup

    #kube
    kind
    kubectl
    kubectx
    kubernetes-helm-wrapped
    calicoctl

    htop
    neofetch
    nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    autojump
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    chromium
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      terminal = "alacritty";
      menu = "wofi --show run";
      bars = [
        {
          fonts.size = 10.0;
          position = "top";
        }
      ];
      output = {
        eDP-1 = {
          scale = "1";
        };
      };
    };
  };

  # basic configuration of git, please change to your own
  programs = {
    git = {
      enable = true;
      userName = "Dae Choi";
      userEmail = "daechoi@outlook.com";
      package = pkgs.gitAndTools.gitFull;
      extraConfig = {
        core.editor = "vim";
        credential.helper = "cache";
      };
    };

    chromium.enable = true;

    tmux = {
      enable = true;
      keyMode = "vi";
      shortcut = "a";
      terminal = "xterm-256color-italic";
      clock24 = true;
      shell = "/etc/profiles/per-user/dchoi/bin/zsh";
    };

    autojump.enable = true;

    alacritty = {
      enable = true;
      # custom settings
      settings = {
        env.TERM = "xterm-256color-italic";
        font = {
          size = 12;
        };
        scrolling.multiplier = 5;
        selection.save_to_clipboard = true;
      };
    };

    # starship - an customizable prompt for any shell
    starship = {
      enable = true;
      #custom settings
      settings = {
        add_newline = false;
        aws.disabled = true;
        gcloud.disabled = true;
        line_break.disabled = true;
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
        vim = "nvim";
        g = "git";
        k = "kubectl";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      envExtra = "export TERM=xterm-256color-italic";
      initExtra = "source ~/.p10k.zsh";
      zplug = {
        enable = true;
        plugins = [
          {
            name = "zsh-users/zsh-autosuggestions";
          } # Simple plugin installation
          {
            name = "romkatv/powerlevel10k";
          } # Installations with additional options. For the list of options, please refer to Zplug README.
        ];
      };
    };
    home-manager.enable = true;
  };
}
