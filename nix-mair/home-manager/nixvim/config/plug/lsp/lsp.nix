{
  plugins = {
    dap = {
      enable = true;
      adapters = {
        servers = {
          codelldb = {
            port = "\${port}";
            executable = {
              command = "~/.local/share/nvim/mason/bin/codelldb";
              args = ["dap" "-l" "127.0.0.1:\$(port)"];
            };
          };
        };
      };
    };
    lsp-format = {enable = true;};
    rustaceanvim.enable = true;
    lsp = {
      enable = true;
      servers = {
        bashls = {enable = true;};
        eslint = {enable = true;};
        html = {enable = true;};
        lua_ls = {enable = true;};
        nil_ls = {enable = true;};
        marksman = {enable = true;};
        pyright = {enable = true;};
        gopls = {enable = true;};
        terraformls = {enable = true;};
        ts_ls = {
          enable = true;
          filetypes = ["javascript" "javascriptreact" "javascript.jsx" "typescript" "typescriptreact" "typescript.tsx"];
          extraOptions = {
            settings = {
              javascript = {
                inlayHints = {
                  includeInlayEnumMemberValueHints = true;
                  includeInlayFunctionLikeReturnTypeHints = true;
                  includeInlayFunctionParameterTypeHints = true;
                  includeInlayParameterNameHints = true;
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                  includeInlayPropertyDeclarationTypeHints = true;
                  includeInlayVariableTypeHints = true;
                };
              };
              typescript = {
                inlayHints = {
                  includeInlayEnumMemberValueHints = true;
                  includeInlayFunctionLikeReturnTypeHints = true;
                  includeInlayFunctionParameterTypeHints = true;
                  includeInlayParameterNameHints = true;
                  includeInlayParameterNameHintsWhenArgumentMatchesName = true;
                  includeInlayPropertyDeclarationTypeHints = true;
                  includeInlayVariableTypeHints = true;
                };
              };
            };
          };
        };
        yamlls = {
          enable = true;
        };
      };
      keymaps = {
        silent = true;
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Type Definition";
          };
          K = {
            action = "hover";
            desc = "Hover";
          };
          "<leader>cw" = {
            action = "workspace_symbol";
            desc = "Workspace Symbol";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename";
          };
        };
        diagnostic = {
          "<leader>cd" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "[d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
        };
      };
    };
    web-devicons.enable = true;
  };
  extraConfigLua = ''
    local _border = "rounded"

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = _border
      }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = _border
      }
    )

    vim.diagnostic.config{
      float={border=_border}
    };

    require('lspconfig.ui.windows').default_options = {
      border = _border
    }
  '';
}
