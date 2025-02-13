DRY vars generator lib for [clan](https://clan.lol)

## How to import in your flake

```nix
clan = {
  specialArgs = {
    varsGenerator = clan-vars-generators.lib { inherit pkgs; };
  };
};
```

## How to use

Now you can use the predefined generators

```nix
{ varsGenerator , ... }:
with varsGenerator;
{
  clan.core.vars.generators.wireguard = varsGenerator.wireguard {};
  clan.core.vars.generators.tinc = varsGenerator.tinc {};
  clan.core.vars.generators.password = varsGenerator.password {};
  clan.core.vars.generators.ssh_host = varsGenerator.ssh {};
  clan.core.vars.generators.ssh_borg = varsGenerator.ssh {};
};
```

> Every `varsGenerator` demands a dict as argument, even some of the generators don't have parameters to be set.
