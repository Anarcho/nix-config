{
  neotest = {
    enable = true;
    adapters = {
      #zig.enable = true;
      python.enable = true;
      bash.enable = true;
      go.enable = true;
      rust.enable = true;
    };
    settings = {
      virtual_text = true;
      consumers.overseer.__raw = ''
        require("neotest.consumers.overseer")
      '';
    };
  };
}
