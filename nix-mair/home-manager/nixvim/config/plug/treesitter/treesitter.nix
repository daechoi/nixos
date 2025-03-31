{pkgs, ...}: let
  nu-grammar = pkgs.tree-sitter.buildGrammar {
    language = "nu";
    version = "0.0.0+rev=358c4f5";
    src = pkgs.fetchFromGitHub {
      owner = "nushell";
      repo = "tree-sitter-nu";
      rev = "2d0dd587dbfc3363d2af4e4141833e718647a67e";
      hash = "sha256-A0Lpsx0VFRYUWetgX3Bn5osCsLQrZzg90unGg9kTnVg=";
    };
  };
in {
  filetype.extension.liq = "liquidsoap";
  filetype.extension.nu = "nu";

  plugins.treesitter = {
    enable = true;
    settings.indent.enable = true;
    folding = true;
    languageRegister.nu = "nu";
    languageRegister.liq = "liquidsoap";
    nixvimInjections = true;

    # First approach: Just disable the problematic grammar
    grammarPackages =
      [
        nu-grammar
      ]
      ++ builtins.filter
      (
        grammar:
          !(pkgs.lib.hasInfix "ocamllex" (builtins.toString grammar))
      )
      (builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins);
  };
  extraConfigLua = ''
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

    parser_config.liquidsoap = {
      filetype = "liquidsoap",
    }
    parser_config.nu = {
      filetype = "nu",
    }
  '';
}
