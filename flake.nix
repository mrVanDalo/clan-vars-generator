{
  description = "clan.lol lib to standardize vars generation";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devshell.url = "github:numtide/devshell";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    clan-core = {
      url = "git+https://git.clan.lol/clan/clan-core";
      inputs.nixpkgs.follows = "nixpkgs"; # Needed if your configuration uses nixpkgs unstable.
      inputs.flake-parts.follows = "flake-parts";
    };

  };

  outputs =
    inputs@{ flake-parts, clan-core, ... }:

    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      imports = [
        ./nix/devshells.nix
        ./nix/formatter.nix
        inputs.clan-core.flakeModules.default
      ];

      # Define your clan
      clan =
        let
          pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
        in
        {
          meta.name = "test";
          specialArgs = {
            varsGenerator = inputs.self.lib { inherit pkgs; };
          };
          machines = {
            test =
              { varsGenerator, ... }:
              {
                imports = [ ];
                nixpkgs.hostPlatform = "x86_64-linux";
                # Set this for clan commands use ssh i.e. `clan machines update`
                clan.core.networking.targetHost = pkgs.lib.mkDefault "root@jon";
                # remote> lsblk --output NAME,ID-LINK,FSTYPE,SIZE,MOUNTPOINT
                disko.devices.disk.main.device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b4aec2929";

                # There needs to be exactly one controller per clan
                clan.core.vars.settings.secretStore = "password-store";
                clan.core.vars.settings.publicStore = "in_repo";

                # tests

                clan.core.vars.generators.password_a = varsGenerator.xkcdpass { };
                clan.core.vars.generators.password_b = varsGenerator.xkcdpass { phrases = 10; };

                clan.core.vars.generators.ssh_a = varsGenerator.openssh { };

                clan.core.vars.generators.matrix_synapse = varsGenerator.matrix-synapse { };

                clan.core.vars.generators.syncthing_a = varsGenerator.syncthing { };

                clan.core.vars.generators.nix_serve = varsGenerator.nix-serve { domain = "test.org"; };

                clan.core.vars.generators.wireguard_a = varsGenerator.wireguard { };

                clan.core.vars.generators.public = varsGenerator.public {
                  ip = "1.2.3.4";
                  cidr = "1.2.3.4/24";
                };

                clan.core.vars.generators.tinc_a = varsGenerator.tinc { };

                clan.core.vars.generators.tor_a = varsGenerator.tor { };
                clan.core.vars.generators.tor_b = varsGenerator.tor { addressPrefix = "b"; };

                clanCore.vars.generators.zfs = varsGenerator.zfs { };

              };
          };
        };

      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {

          # Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
          devShells.default = pkgs.mkShell {
            packages = [
              clan-core.packages.${system}.clan-cli
            ];
          };

          # test vavarnerators creation
          apps.default = {
            type = "app";
            program = pkgs.writers.writeBashBin "test" ''
              export PASSWORD_STORE_DIR=$(mktemp -d)
              echo PASSWORD_STORE_DIR=$PASSWORD_STORE_DIR
              ${pkgs.pass}/bin/pass init 389EC2D64AC71EAC
              ${clan-core.packages.${system}.clan-cli}/bin/clan vars generate test
              ${clan-core.packages.${system}.clan-cli}/bin/clan vars list test
              echo export PASSWORD_STORE_DIR=$PASSWORD_STORE_DIR
              pass list
              tree vars
              echo "deleting machines folder"
              rm -rf machines
            '';
          };

        };
      flake = {
        lib = import ./lib/generators;
      };
    };
}
