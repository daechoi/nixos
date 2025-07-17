{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [

    # dev
    gcc
    ruff
    pyright

    # Go development
    go
    gopls
    gofumpt
    golangci-lint
    delve # Go debugger

    # Rust
    rustc
    cargo
    rust-analyzer
    rustfmt
    lldb # LLDB debugger for Rust

    # Python debugging
    python3Packages.debugpy

    # Shell/Bash dev
    bash-language-server
    shellcheck
    shfmt

    # JSON/YAML formatters
    nodePackages.prettier # For JSON and YAML formatting
    # Alternative: you already have jq for JSON

    #kube
    #    kind
    #    kubectl
    #    kubectx
    #    kustomize
    #    envsubst
    #    doctl
    age
    docker-sync

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
    eza # A modern replacement for 'ls'
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

    terraform
    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    damon

    devenv
    # productivity
    hugo # static site generator

    # virtualization
    colima
    docker
    docker-compose
    podman-compose
    podman-tui
    podman
    nomad

    natscli

    qemu
    # shell
    autojump
    #nomad-driver-podman
    #    font-awesome
    #    noto-fonts-emoji
    awscli
  ];

  # basic configuration of git, please change to your own
  programs = {
    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_mocha";
        editor = {
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          lsp = {
            display-messages = true;
            auto-signature-help = true;
            display-inlay-hints = true;
            display-signature-help-docs = true;
          };
          auto-format = true;
          auto-save = true;
        };
      };

      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
          }
          {
            name = "python";
            auto-format = true;
            language-servers = [
              "pyright"
              "ruff"
            ];
            debugger = {
              name = "debugpy";
              transport = "stdio";
              command = "${pkgs.python3Packages.debugpy}/bin/python";
              args = [
                "-m"
                "debugpy.adapter"
              ];
              templates = [
                {
                  name = "source";
                  request = "launch";
                  completion = [
                    {
                      name = "entrypoint";
                      completion = "filename";
                      default = ".";
                    }
                  ];
                  args = {
                    mode = "debug";
                    program = "{0}";
                  };
                }
              ];
            };
            formatter = {
              command = "${pkgs.ruff}/bin/ruff";
              args = [
                "format"
                "--stdin-filename"
                "file.py"
                "-"
              ];
            };
            file-types = [
              "py"
              "pyi"
              "py3"
              "pyw"
            ];
            roots = [
              "pyproject.toml"
              "setup.py"
              "setup.cfg"
              "requirements.txt"
              "Pipfile"
              "pyrightconfig.json"
            ];
            indent = {
              tab-width = 4;
              unit = "    ";
            };
          }
          {
            name = "rust";
            auto-format = true;
            language-servers = [ "rust-analyzer" ];
            debugger = {
              name = "lldb-dap";
              transport = "stdio";
              command = "${pkgs.lldb}/bin/lldb-dap";
              templates = [
                {
                  name = "binary";
                  request = "launch";
                  completion = [
                    {
                      name = "binary";
                      completion = "filename";
                    }
                  ];
                  args = {
                    program = "{0}";
                    console = "internalConsole";
                    stopOnEntry = false;
                  };
                }
                {
                  name = "attach";
                  request = "attach";
                  completion = [
                    {
                      name = "pid";
                      completion = "pid";
                    }
                  ];
                  args = {
                    pid = "{0}";
                  };
                }
              ];
            };
            formatter = {
              command = "${pkgs.rustfmt}/bin/rustfmt";
              args = [
                "--edition"
                "2021"
              ];
            };
            file-types = [ "rs" ];
            roots = [
              "Cargo.toml"
              "Cargo.lock"
            ];
            indent = {
              tab-width = 4;
              unit = "    ";
            };
          }
          {
            name = "go";
            auto-format = true;
            language-servers = [ "gopls" ];
            debugger = {
              name = "delve";
              transport = "stdio";
              command = "${pkgs.delve}/bin/dlv";
              args = [ "dap" ];
              port-arg = "--listen=127.0.0.1:{}";
              templates = [
                {
                  name = "source";
                  request = "launch";
                  completion = [
                    {
                      name = "entrypoint";
                      completion = "filename";
                      default = ".";
                    }
                  ];
                  args = {
                    mode = "debug";
                    program = "{0}";
                  };
                }
                {
                  name = "binary";
                  request = "launch";
                  completion = [
                    {
                      name = "binary";
                      completion = "filename";
                    }
                  ];
                  args = {
                    mode = "exec";
                    program = "{0}";
                  };
                }
                {
                  name = "test";
                  request = "launch";
                  completion = [
                    {
                      name = "tests";
                      completion = "directory";
                      default = ".";
                    }
                  ];
                  args = {
                    mode = "test";
                    program = "{0}";
                  };
                }
                {
                  name = "attach";
                  request = "attach";
                  completion = [
                    {
                      name = "pid";
                      completion = "pid";
                    }
                  ];
                  args = {
                    mode = "local";
                    processId = "{0}";
                  };
                }
              ];
            };
            formatter = {
              command = "${pkgs.gofumpt}/bin/gofumpt";
              args = [ ];
            };
            file-types = [ "go" ];
            roots = [
              "go.mod"
              "go.sum"
              "go.work"
            ];
            indent = {
              tab-width = 4;
              unit = "	"; # Go uses tabs
            };
          }
          {
            name = "bash";
            auto-format = true;
            language-servers = [ "bash-language-server" ];
            formatter = {
              command = "${pkgs.shfmt}/bin/shfmt";
              args = [
                "-i"
                "2"
                "-ci"
              ]; # 2 spaces, indent switch cases
            };
            file-types = [
              "sh"
              "bash"
              "zsh"
            ];
            shebangs = [
              "sh"
              "bash"
              "zsh"
            ];
            roots = [ ];
            indent = {
              tab-width = 2;
              unit = "  ";
            };
          }
          {
            name = "json";
            auto-format = true;
            formatter = {
              command = "${pkgs.jq}/bin/jq";
              args = [ "." ];
            };
            # Alternative prettier configuration (commented out):
            # formatter = {
            #   command = "${pkgs.nodePackages.prettier}/bin/prettier";
            #   args = [ "--parser" "json" ];
            # };
            file-types = [
              "json"
              "jsonc"
            ];
            roots = [ "package.json" ];
            indent = {
              tab-width = 2;
              unit = "  ";
            };
          }
          {
            name = "yaml";
            auto-format = true;
            formatter = {
              command = "${pkgs.nodePackages.prettier}/bin/prettier";
              args = [
                "--parser"
                "yaml"
              ];
            };
            # Alternative using yq (commented out):
            # formatter = {
            #   command = "${pkgs.yq-go}/bin/yq";
            #   args = [ "eval" "." "-" ];
            # };
            file-types = [
              "yaml"
              "yml"
            ];
            roots = [
              ".github/workflows"
              "docker-compose.yaml"
              "docker-compose.yml"
              ".gitlab-ci.yml"
            ];
            indent = {
              tab-width = 2;
              unit = "  ";
            };
          }
          {
            name = "env";
            # No LSP available for .env files, but we can configure syntax
            file-types = [ "env" ];
            indent = {
              tab-width = 2;
              unit = "  ";
            };
          }
          # Alternative: dockerfile support (bonus)
          {
            name = "dockerfile";
            language-servers = [ "docker-langserver" ];
            file-types = [
              "dockerfile"
              "Dockerfile"
              "Containerfile"
            ];
            roots = [
              "Dockerfile"
              "Containerfile"
            ];
            indent = {
              tab-width = 2;
              unit = "  ";
            };
          }
        ];

        language-server = {
          # Python
          pyright = {
            command = "${pkgs.pyright}/bin/pyright-langserver";
            args = [ "--stdio" ];
            config = {
              python = {
                analysis = {
                  typeCheckingMode = "basic";
                  autoSearchPaths = true;
                  useLibraryCodeForTypes = true;
                  autoImportCompletions = true;
                  diagnosticMode = "workspace";
                  stubPath = "";
                  diagnosticSeverityOverrides = {
                    reportUnusedImport = "information";
                    reportUnusedVariable = "information";
                    reportOptionalMemberAccess = "warning";
                    reportOptionalSubscript = "warning";
                    reportPrivateImportUsage = "warning";
                  };
                };
              };
            };
          };
          ruff = {
            command = "${pkgs.ruff}/bin/ruff";
            args = [
              "server"
              "--preview"
            ];
            config = {
              settings = {
                args = [ "pyproject.toml" ];
                logLevel = "info";
              };
            };
          };

          # Rust
          rust-analyzer = {
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
            config = {
              checkOnSave = {
                command = "clippy";
                extraArgs = [ "--no-deps" ];
              };
              cargo = {
                features = "all";
              };
              procMacro = {
                enable = true;
              };
              diagnostics = {
                enable = true;
                experimental.enable = true;
              };
            };
          };

          # Go
          gopls = {
            command = "${pkgs.gopls}/bin/gopls";
            config = {
              gofumpt = true;
              staticcheck = true;
              usePlaceholders = true;
              completeUnimported = true;
              matcher = "fuzzy";
              experimentalWorkspaceModule = true;
              hoverKind = "SynopsisDocumentation";
              linkTarget = "pkg.go.dev";
            };
          };

          # Bash
          bash-language-server = {
            command = "${pkgs.bash-language-server}/bin/bash-language-server";
            args = [ "start" ];
            config = {
              bashIde = {
                globPattern = "**/*@(.sh|.inc|.bash|.command)";
                shellcheckPath = "${pkgs.shellcheck}/bin/shellcheck";
              };
            };
          };

          # Bonus: Docker (if you want it)
          docker-langserver = {
            command = "${pkgs.dockerfile-language-server-nodejs}/bin/docker-langserver";
            args = [ "--stdio" ];
          };
        };
      };

      themes = {
        autumn_night_transparent = {
          "inherits" = "autumn_night";
          "ui.background" = { };
        };
      };
    };

    git = {
      enable = true;
      userName = "Dae Choi";
      userEmail = "daechoi@outlook.com";
      package = pkgs.git;
      extraConfig = {
        core.editor = "hx";
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

        set-option -g status-left "#[bg=colour241,fg=colour248] #S #[bg=colour237,fg=colour241,nobold,noitalics,nounderscore]"
        set-option -g status-right "#[bg=colour237,fg=colour239 nobold, nounderscore, noitalics]#[bg=colour239,fg=colour246] %Y-%m-%d  %H:%M #[bg=colour239,fg=colour248,nobold,noitalics,nounderscore]#[bg=colour248,fg=colour237] #h "

        set-window-option -g window-status-current-format "#[bg=colour214,fg=colour237,nobold,noitalics,nounderscore]#[bg=colour214,fg=colour239] #I #[bg=colour214,fg=colour239,bold] #W #[bg=colour237,fg=colour214,nobold,noitalics,nounderscore]"
        set-window-option -g window-status-format "#[bg=colour239,fg=colour237,noitalics]#[bg=colour239,fg=colour223] #I #[bg=colour239,fg=colour223] #W #[bg=colour237,fg=colour239,noitalics]"
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
        update = "sudo darwin-rebuild switch --flake /Users/dchoi/.nixos/sabi";
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
      initContent = ''
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
            tags = [
              "as:theme"
              "depth:1"
            ];
          } # Installations with additional options. For the list of options, please refer to Zplug README.
        ];
      };
    };
    home-manager.enable = true;
  };
}
