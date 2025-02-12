{ pkgs, ... }:
with pkgs.lib;
{

  # define public facts in code
  public = nameValues: {
    files = mapAttrs (_name: value: { secret = false; }) nameValues;
    runtimeInputs = with pkgs; [ coreutils ];
    script =
      let
        echoLine = mapAttrsToList (name: value: ''
          echo -n "${value}" > $out/${name}
        '') nameValues;
      in
      concatStringsSep "\n" echoLine;
  };

}
