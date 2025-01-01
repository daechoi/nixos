{
  config,
  pkgs,
  inputs,
  ...
}: let
  neovimconfig = import ../nixvim/config;
  nvim = inputs.nixvim.legacyPackages.aarch64-darwin.makeNixvimWithModule {
    inherit pkgs;
    module = neovimconfig;
  };
in {
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them
    nvim

    # dev
    #    gnumake
    #kube
    #    kind
    #    kubectl
    #    kubectx
    #    kustomize
    #    envsubst
    #    doctl

    htop
    #    neofetch
    #    nnn # terminal file manager

    # archives
    #    zip
    #    xz
    #    unzip
    #    p7zip

    # utils
    libqalculate # A powerful and easy to use desktop calculator
    autojump
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    direnv # An environment switcher for the shell
    bunyan-rs # A JSON CLI logger:w
    #    networkmanager

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

    pandoc
    tectonic

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    damon

    devenv
    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    # virtualization
    colima
    docker
    docker-compose
    podman-compose
    podman-tui
    podman
    nomad

    qemu
    # shell
    autojump
    #nomad-driver-podman
    #    font-awesome
    #    noto-fonts-emoji
  ];

  # basic configuration of git, please change to your own
  programs = {
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        # Looks
        jdinhlife.gruvbox
        pkief.material-icon-theme

        # Languages
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        serayuzgur.crates

        bbenoist.nix
        brettm12345.nixfmt-vscode

        thenuprojectcontributors.vscode-nushell-lang

        yzhang.markdown-all-in-one
        marp-team.marp-vscode

        haskell.haskell

        # Copilot
        #        github.copilot

        # Misc
        mkhl.direnv
        ms-vscode.live-server
      ];
    };

    git = {
      enable = true;
      userName = "Dae Choi";
      userEmail = "daechoi@outlook.com";
      package = pkgs.gitAndTools.gitFull;
      extraConfig = {
        core.editor = "vim";
        credential.helper = "cache";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };

    tmux = {
      enable = true;
      sensibleOnTop = false;
      keyMode = "vi";
      prefix = "M-a";
      terminal = "xterm-256color-italic";
      shell = "${pkgs.zsh}/bin/zsh";
      mouse = true;
      customPaneNavigationAndResize = false;
      extraConfig = ''
        unbind C-b
        set-option -g prefix M-a
        set -g default-terminal xterm-256color-italic
        bind C-a send-prefix

        bind-key -r k select-pane -U
        bind-key -r j select-pane -D
        bind-key -r h select-pane -L
        bind-key -r l select-pane -R


        # resize panes with VIM nav keys
        bind -r C-h resize-pane -L
        bind -r C-j resize-pane -D
        bind -r C-k resize-pane -U
        bind -r C-l resize-pane -R


        set-option -g status "on"
        set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1
        set-window-option -g window-status-style bg=colour214,fg=colour237 # bg=yellow, fg=bg1
        set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

        # active window title colors
        set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1

        # pane border
        set-option -g pane-active-border-style fg=colour250 #fg2
        set-option -g pane-border-style fg=colour237 #bg1

        # message infos
        set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1
        # writing commands inactive
        set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1

        # pane number display
        set-option -g display-panes-active-colour colour250 #fg2
        set-option -g display-panes-colour colour237 #bg1

        # clock
        set-window-option -g clock-mode-colour colour109 #blue

        # bell
        set-window-option -g window-status-bell-style bg=colour167,fg=colour235 # bg=red, fg=bg

        # Theme settings mixed with colors (unfortunately, but there is no cleaner way)
        set-option -g status-justify "left"
        set-option -g status-left-style none
        set-option -g status-left-length "80"
        set-option -g status-right-style none
        set-option -g status-right-length "80"
        set-window-option -g window-status-separator ""

        set-option -g status-left "#[bg=colour241,fg=colour248] #S #[bg=colour237,fg=colour241,nobold,noitalics,nounderscore]"
        set-option -g status-right "#[bg=colour237,fg=colour239 nobold, nounderscore, noitalics]#[bg=colour239,fg=colour246] %Y-%m-%d  %H:%M #[bg=colour239,fg=colour248,nobold,noitalics,nounderscore]#[bg=colour248,fg=colour237] #h "

        set-window-option -g window-status-current-format "#[bg=colour214,fg=colour237,nobold,noitalics,nounderscore]#[bg=colour214,fg=colour239] #I #[bg=colour214,fg=colour239,bold] #W #[bg=colour237,fg=colour214,nobold,noitalics,nounderscore]"
        set-window-option -g window-status-format "#[bg=colour239,fg=colour237,noitalics]#[bg=colour239,fg=colour223] #I #[bg=colour239,fg=colour223] #W #[bg=colour237,fg=colour239,noitalics]"
        # set -g status-right "#(/usr/bin/env bash $HOME/.tmux/kube-tmux/kube.tmux 250 red cyan)"
      '';
    };

    autojump.enable = true;

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "darwin-rebuild switch --flake /Users/dchoi/.nixos/sabi";
        vim = "nvim";
        g = "git";
        k = "kubectl";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        psql = "nix shell nixpkgs#postgresql --command psql";
      };

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      envExtra = ''
        export TERM=xterm-256color-italic
        export CLICOLOR=1
      '';
      initExtra = ''
        function lll() {
          tree -aC -L 3 -I '.git|node_modules|target' --dirsfirst "$@" | less -FRNX;
        }
        function llll() {
          tree -aC -L 4 -I '.git|node_modules|target' --dirsfirst "$@" | less -FRNX;
        }
        function lllll() {
          tree -aC -L 5 -I '.git|node_modules|target' --dirsfirst "$@" | less -FRNX;
        }

        source ~/.p20k.zsh;
        export PATH=$PATH:/Users/dchoi/.cargo/bin:/Users/dchoi/.scripts/bin:/Users/dchoi/.local/bin:/Users/dchoi/.npm-global/bin;
        eval "$(direnv hook zsh)";
      '';
      zplug = {
        enable = true;
        plugins = [
          {
            name = "zsh-users/zsh-autosuggestions";
          } # Simple plugin installation
          {
            name = "romkatv/powerlevel10k";
            tags = [as:theme depth:1];
          } # Installations with additional options. For the list of options, please refer to Zplug README.
        ];
      };
    };
    home-manager.enable = true;
  };
}
