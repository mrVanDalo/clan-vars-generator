{ pkgs, ... }:
{

  tinc = _: {
    files."rsa_key.priv" = { };
    files."ed25519_key.priv" = { };
    files."rsa_key.pub" = {
      secret = false;
    };
    files."ed25519_key.pub" = {
      secret = false;
    };
    runtimeInputs = with pkgs; [
      coreutils
      tinc_pre
      gnugrep
      gawk
    ];
    script = ''
      tinc --config "$out" generate-keys 4096 >/dev/null
      cat "$out/ed25519_key.pub" | grep 'Ed25519PublicKey =' | awk '{print $3}' | tr -d '\n' > "$out"/_ed25519_key.pub
      mv "$out/_ed25519_key.pub" "$out/ed25519_key.pub"
    '';
  };

}
