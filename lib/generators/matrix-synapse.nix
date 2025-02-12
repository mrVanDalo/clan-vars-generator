{ pkgs, ... }:
{

  matrix-synapse = _: {
    files."registration_shared_secret.yml" = { };
    runtimeInputs = with pkgs; [
      coreutils
      pwgen
    ];
    script = ''
      echo "registration_shared_secret: $(pwgen -s 32 1)" > "$out"/registration_shared_secret.yml
    '';
  };

}
