{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nixvim,
    ...
  }: let
    system = "aarch64-darwin";
    pkgs = import nixpkgs {
      inherit system;
    };

    lib = pkgs.lib;
    configuration = {pkgs, ...}: {
      services = {
        nix-daemon.enable = true;
        yabai = {
          enable = true;
          package = pkgs.yabai;
          enableScriptingAddition = true;
          config = {
            #            focus_follows_mouse = "autoraise";
            #            mouse_follows_focus = "off";
            window_placement = "second_child";
            window_opacity = "off";
            window_opacity_duration = "0.0";
            window_topmost = "on";
            window_shadow = "float";
            active_window_opacity = "1.0";
            normal_window_opacity = "1.0";
            split_ratio = "0.50";
            auto_balance = "on";
            mouse_modifier = "fn";
            mouse_action1 = "move";
            mouse_action2 = "resize";
            layout = "bsp";
            top_padding = 2;
            bottom_padding = 2;
            left_padding = 2;
            right_padding = 2;
            window_gap = 2;
          };

          extraConfig = ''
            # rules
            yabai -m rule --add app='System Preferences' manage=off

            # Any other arbitrary config here
          '';
        };
        skhd = {
          enable = true;
          skhdConfig = ''
             alt - h : yabai -m window --focus west
             alt - j : yabai -m window --focus south
             alt - k : yabai -m window --focus north
             alt - l : yabai -m window --focus east

            # swap managed window
             shift + alt - h : yabai -m window --swap north

             # move managed window
             shift + alt - h : yabai -m window --warp west
             shift + alt - j : yabai -m window --warp south
             shift + alt - k : yabai -m window --warp north
             shift + alt - l : yabai -m window --warp east

             # balance size of windows
             shift + alt - 0 : yabai -m space --balance

             # make floating window fill screen
             shift + alt - up     : yabai -m window --grid 1:1:0:0:1:1

             # make floating window fill left-half of screen
             shift + alt - a : yabai -m window --grid 1:2:0:0:1:1
             shift + alt - d : yabai -m window --grid 1:2:0:0:2:1

             # create desktop, move window and follow focus - uses jq for parsing json (brew install jq)
             #shift + cmd - n : yabai -m space --create && \

             # fast focus desktop
             cmd + alt - x : yabai -m space --focus recent
             cmd + alt - 1 : yabai -m space --focus 1

             # send window to desktop and follow focus
             shift + alt - n : yabai -m window --space next && yabai -m space --focus next
             shift + alt - p : yabai -m window --space prev && yabai -m space --focus prev
             shift + alt - 1 : yabai -m window --space  1 && yabai -m space --focus 1
             shift + alt - 2 : yabai -m window --space  2 && yabai -m space --focus 2
             shift + alt - 3 : yabai -m window --space  3 && yabai -m space --focus 3
             shift + alt - 4 : yabai -m window --space  4 && yabai -m space --focus 4
             shift + alt - 5 : yabai -m window --space  5 && yabai -m space --focus 5
             shift + alt - 6 : yabai -m window --space  6 && yabai -m space --focus 6
             shift + alt - 7 : yabai -m window --space  7 && yabai -m space --focus 7
             shift + alt - 8 : yabai -m window --space  8 && yabai -m space --focus 8
             shift + alt - 9 : yabai -m window --space  9 && yabai -m space --focus 9
             shift + alt - 0 : yabai -m window --space  10 && yabai -m space --focus 10


             # focus monitor
             ctrl + alt - z  : yabai -m display --focus prev
             # ctrl + alt - 3  : yabai -m display --focus 3

             # send window to monitor and follow focus
             # ctrl + cmd - c  : yabai -m window --display next; yabai -m display --focus next
             # ctrl + cmd - 1  : yabai -m window --display 1; yabai -m display --focus 1

             # move floating window
             # shift + ctrl - a : yabai -m window --move rel:-20:0
             # shift + ctrl - s : yabai -m window --move rel:0:20

             # increase window size
             # shift + alt - a : yabai -m window --resize left:-20:0
             # shift + alt - w : yabai -m window --resize top:0:-20

             # decrease window size
             # shift + cmd - s : yabai -m window --resize bottom:0:-20
             # shift + cmd - w : yabai -m window --resize top:0:20

             # set insertion point in focused container
             # ctrl + alt - h : yabai -m window --insert west

             # todo up

             # toggle window zoom
             alt - d : yabai -m window --toggle zoom-parent
             alt - f : yabai -m window --toggle zoom-fullscreen

             # toggle window split type
             alt - e : yabai -m window --toggle split

             # float / unfloat window and center on screen
             alt - t : yabai -m window --toggle float;\
                       yabai -m window --grid 4:4:1:1:2:2

             # toggle sticky(+float), topmost, border and picture-in-picture
             alt - p : yabai -m window --toggle sticky;\
                       yabai -m window --toggle topmost;\
                       yabai -m window --toggle border;\
                       yabai -m window --toggle pip

             # cmd + shift - n : exec /System/Applications/Notes.app/Contents/MacOS/Notes
          '';
        };
      };
      nix.settings.experimental-features = "nix-command flakes";
      programs = {
        zsh.enable = true;
      };

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nixpkgs = {
        hostPlatform = system;
        config.allowUnfree = true;
      };
    };
  in {
    darwinConfigurations.sabi = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            verbose = true;
            users.dchoi = import ./home-manager;
            extraSpecialArgs = {inherit inputs;};
          };
        }
      ];
    };

    darwinPackages = self.darwinConfigurations.sabi.pkgs;
  };
}
