{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "hlchunk";
      src = pkgs.fetchFromGitHub {
        owner = "shellRaining";
        repo = "hlchunk.nvim";
      };

      # Add runtime paths explicitly
      buildPhase = ''
        mkdir -p $out/lua
        cp -r lua/* $out/lua/
      '';
    })
  ];

  extraConfigLua = ''
    require('hlchunk').setup({
      chunk = {
        enable = true,
        support_filetypes = {
          '.*',
        },
        chars = {
          horizontal_line = "─",
          vertical_line = "│",
          left_top = "╭",
          left_bottom = "╰",
          right_arrow = ">",
        },
        style = "#00ffff",
      },
      indent = {
        enable = true,
        use_treesitter = false,
      },
      line_num = {
        enable = true,
      },
      blank = {
        enable = true,
      },
    })
  '';
}
