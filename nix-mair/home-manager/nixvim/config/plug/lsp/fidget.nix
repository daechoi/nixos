{
  plugins.fidget = {
    enable = true;
    settings = {
      logger = {
        level = "warn";
        floatPrecision = 0.01;
      };
      progress = {
        pollRate = 0;
        suppressOnInsert = true;
        ignoreDoneAlready = false;
        ignoreEmptyMessage = false;
        clearOnDetach = {
          __lua = ''
            return function(client_id)
              local client = vim.lsp.get_client_by_id(client_id)
              return client and client.name or nil
            end
          '';
        };
        notificationGroup = {
          __lua = ''
            return function(msg)
              return msg.lsp_client.name
            end
          '';
        };
        ignore = [];
        lsp = {
          progressRingbufSize = 0;
        };
        display = {
          renderLimit = 16;
          doneTtl = 3;
          doneIcon = "✔";
          doneStyle = "Constant";
          progressTtl = "math.huge";
          progressIcon = {
            pattern = "dots";
            period = 1;
          };
          progressStyle = "WarningMsg";
          groupStyle = "Title";
          iconStyle = "Question";
          priority = 30;
          skipHistory = true;
          formatMessage = {
            __lua = ''
              return require("fidget.progress.display").default_format_message
            '';
          };
          formatAnnote = {
            __lua = ''
              return function(msg)
                return msg.title
              end
            '';
          };
          formatGroupName = {
            __lua = ''
              return function(group)
                return tostring(group)
              end
            '';
          };
          overrides = {
            rust_analyzer = {
              name = "rust-analyzer";
            };
          };
        };
      };
      notification = {
        pollRate = 10;
        filter = "info";
        historySize = 128;
        overrideVimNotify = true;
        configs = {
          default = {
            __lua = ''
              return require("fidget.notification").default_config
            '';
          };
        };
        window = {
          normalHl = "Comment";
          winblend = 0;
          border = "none";
          zindex = 45;
          maxWidth = 0;
          maxHeight = 0;
          xPadding = 1;
          yPadding = 0;
          align = "bottom";
          relative = "editor";
        };
        view = {
          stackUpwards = true;
          iconSeparator = " ";
          groupSeparator = "---";
          groupSeparatorHl = "Comment";
        };
      };
    };
  };
}
