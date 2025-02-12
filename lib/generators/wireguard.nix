{ pkgs, ... }:
{

  wireguard = _: {
    files."wireguard.key" = { };
    files."wireguard.pub" = {
      secret = false;
    };
    runtimeInputs = with pkgs; [
      coreutils
      wireguard-tools
    ];
    script = ''
      wg genkey > "$out"/wireguard.key
      cat "$out/wireguard.key" | wg pubkey | tr -d '\n' > "$out"/wireguard.pub
    '';
  };

}
