{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    monospace = ["JetBrainsMono"];
  };

  home.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
  ];
}
