{ pkgs, ... }:
{
  tor =
    {
      addressPrefix ? "clan",
    }:
    {
      files."hs_ed25519_secret_key" = { };
      files."hs_ed25519_public_key" = { };
      files."hostname" = { };
      runtimeInputs = with pkgs; [
        coreutils
        mkp224o
      ];
      script = ''
        mkp224o-donna ${addressPrefix} -n 1 -d . -q -O addr
        mv "$(cat addr)/hs_ed25519_secret_key" "$out/hs_ed25519_secret_key"
        mv "$(cat addr)/hs_ed25519_public_key" "$out/hs_ed25519_public_key"
        mv addr "$out/hostname"
      '';
    };

}
