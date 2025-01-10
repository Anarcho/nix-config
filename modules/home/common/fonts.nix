{pkgs, ...}: {
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    monospace = ["Fira Code"];
  };

  home.packages = with pkgs; [
    fira-code
    fira-code-symbols
  ];
}
