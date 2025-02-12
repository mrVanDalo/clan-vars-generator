{ pkgs, ... }:
{
  openssh = _: {
    files."ssh.id_ed25519" = { };
    files."ssh.id_ed25519.pub" = {
      secret = false;
    };
    runtimeInputs = with pkgs; [
      coreutils
      openssh
    ];
    script = ''
      ssh-keygen -t ed25519 -N "" -f $out/ssh.id_ed25519
      cat $out/ssh.id_ed25519.pub | tr -d '\n' > $out/ssh.id_ed25519.pub
    '';
  };

}
