{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    firefox
  ];

  programs = {
    bat.enable = true;
    fzf.enable = true;
    jq.enable = true;
    btop.enable = true;
    tmate = {
      enable = true;
    };

    # Terminals
    ghostty.enable = true;
  };
}
