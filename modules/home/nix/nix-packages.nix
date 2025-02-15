{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  #home.packages = with pkgs; [
  #];

  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    btop.enable = true;
    tmate = {
      enable = true;
    };
    chromium = {
      enable = true;
      package = pkgs.brave;
    };
  };
}
