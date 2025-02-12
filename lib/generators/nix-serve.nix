{ pkgs, ... }:
{

  # name must be set, such as cache.example.org-1. Is seen by client
  nix-serve =
    { domain }:
    {
      files."nix-serve.key" = { };
      files."nix-serve.pub" = {
        secret = false;
      };
      runtimeInputs = with pkgs; [
        coreutils
        nix
      ];
      script = ''
        nix-store --generate-binary-cache-key "${domain}" $out/nix-serve.key $out/nix-serve.pub
      '';
    };
}
