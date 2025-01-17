{
  flake,
  lib,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops = {
    defaultSopsFile = "${inputs.mysecrets/secrets.yaml}";
    age = {
      sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
      "anthropic-key" = {
        owner = "aaronk";
        group = "users";
        mode = "0400";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    age
    sops
  ];
}
