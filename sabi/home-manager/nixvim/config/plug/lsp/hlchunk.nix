{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "hlchunk";
      src = pkgs.fetchFromGitHub {
        owner = "shellRaining";
        repo = "hlchunk.nvim";
        rev = "882d1bc86d459fa8884398223c841fd09ea61b6b";
        hash = "sha256-fvFvV7KAOo7xtOCjhGS5bDUzwd10DndAKs3++dunED8=";
      };
      meta.homepage = "https://github.com/shellRaining/hlchunk.nvim";
    })
  ];

  # Add the plugin configuration
  plugins.hlchunk = {
    enable = true;
    # Ensure lua/ directory is in runtimepath
    extraConfig = ''
      lua << EOF
      require('hlchunk').setup({
        chunk = {
          enable = true,
          support_filetypes = {
            '.*', -- supports all filetypes
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
      EOF
    '';
  };
}
