{ pkgs, ... }:
{

  syncthing = _: {
    files."key.pem" = { };
    files."cert.pem" = { };
    files."key.pub" = {
      secret = false;
    };
    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
      syncthing
    ];
    script = ''
      syncthing generate --config "$out"
      cat "$out"/config.xml | grep -oP '(?<=<device id=")[^"]+' | uniq | tr -d '\n' > "$out"/key.pub
    '';
  };

}
