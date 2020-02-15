import pathlib
from prompt_toolkit import print_formatted_text, HTML

def RewriteConfiguration(install_root, username, machine, hostname):
    # TODO(breakds) Use nixos-version to get the NixOS version first
    #   ret = subprocess.run(['nixos-version'], capture_output=True)
    #   print(ret.stdout)

    with open('/etc/machine-id', 'r') as f:
        machine_id = f.read(8)

    config_path = pathlib.Path(install_root, 'etc/nixos/configuration.nix')
    config_path.parent.mkdir(parents=True, exist_ok=True)
    with open(config_path, 'w') as out:
        out.write('{ config, pkgs, ... }:\n\n')
        out.write('{\n')
        out.write('  imports = [\n')
        out.write('    ./hardware-configuration.nix\n')
        out.write('    ./nixvital/machines/{}\n'.format(machine))
        out.write('  ];\n\n')
        out.write('  vital.mainUser = "{}";\n'.format(username))
        out.write('  networking.hostName = "{}";\n'.format(hostname))
        out.write('  networking.hostId = "{}";\n'.format(machine_id))
        out.write('\n')
        out.write('  # This value determines the NixOS release with which your system is to be\n')
        out.write('  # compatible, in order to avoid breaking some software such as database\n')
        out.write('  # servers. You should change this only after NixOS release notes say you\n')
        out.write('  # should.\n')
        out.write('  system.stateVersion = "19.09"; # Did you read the comment?\n')
        out.write('}\n')
    print_formatted_text(HTML(
        'Main configuration generated at <green>{}</green>'.format(
            config_path)))
