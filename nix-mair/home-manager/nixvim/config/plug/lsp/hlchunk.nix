{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "hlchunk";
      src = pkgs.fetchFromGitHub {
        owner = "shellRaining";
        repo = "hlchunk.nvim";
        rev = "refs/tags/v1.3.0";
        hash = "sha256-UGxrfFuLJETL/KJNY9k4zehxb6RrXC6UZxnG+7c9JXw=";
      };
    })
  ];

  extraConfigLua = ''
    vim.opt.list = true
    vim.opt.listchars:append "space:⋅"
    vim.opt.listchars:append "eol:↴"

    require('hlchunk').setup({
      chunk = {
        enable = true,
        support_filetypes = {
          '*',
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
