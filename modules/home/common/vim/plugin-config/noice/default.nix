{pkgs, ...}: {
  noice = {
    enable = true;
    settings.presets = {
      bottom_search = true;
      command_palette = true;
      long_message_to_split = true;
    };
  };
}
