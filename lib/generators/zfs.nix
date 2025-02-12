{ pkgs, ... }:
{

  zfs = _: {
    files."hostId" = {
      secret = false;
    };
    runtimeInputs = with pkgs; [ coreutils ];
    script = ''
      head -c4 /dev/urandom | od -A none -t x4 | tr -d ' ' | tr -d '\n' > "$out"/hostId
    '';
  };

}
