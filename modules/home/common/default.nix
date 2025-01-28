# A module that automatically imports everything else in the parent folder.
{
  imports = with builtins;
    map
    (fn: ./${fn})
    (filter (fn: fn != "default.nix" && !(fn == "vim" || builtins.match "vim/.*" fn != null)) (attrNames (readDir ./.)));
}
