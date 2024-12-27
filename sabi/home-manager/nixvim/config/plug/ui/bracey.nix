NOT USED
{pkgs, ...}: {
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "bracey.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "turbio";
        repo = "bracey.nvim";
        rev = "master";
        #        rev = "4e1a22acc01787814819df1057d039d4ecf357eb";
        #        rev = "47f6419e90d3383987fd06e8f3e06a4bc032ac83";
        #        hash = "sha256-91DZUfa4FBvXnkcNHdllr82Dr1Ie+MGVD3ibwkqo04c=";
      };
    })
  ];

  #  extraConfigLua = ''
  #    require('btw').setup({
  #      text = "I use Neovim (and NixOS, BTW)",
  #    })
  #  '';
}
