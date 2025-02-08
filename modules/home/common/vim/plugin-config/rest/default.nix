{
  rest = {
    enable = true;
    settings = {
      result = {
        show_url = true;
        show_http_info = true;
        show_headers = true;
        request = {
          skip_ssl_verification = false;
          hooks = {
            encode_url = true;
            user_agent = "rest.nvim";
            set_content_type = true;
          };
        };
        response = {
          hooks = {
            decode_url = true;
            format = true;
          };
        };
        env = {
          enable = true;
          pattern = ".*%.env.*";
        };
        ui = {
          keybinds = {
            next = "L";
            prev = "H";
          };
          winbar = true;
        };
        highlight = {
          enable = true;
          timeout = 750;
        };
      };
    };
  };
}
