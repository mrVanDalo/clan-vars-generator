{ pkgs, ... }:
{

  xkcdpass =
    {
      phrases ? 4,
    }:
    {
      files."password" = { };
      files."password.pam" = { };

      runtimeInputs = with pkgs; [
        coreutils
        nix
        xkcdpass
        mkpasswd
      ];

      script = ''
        xkcdpass -n ${toString phrases} -d - > $out/password
        cat $out/password | mkpasswd -s -m sha-512 > $out/password.pam
      '';
    };

}
