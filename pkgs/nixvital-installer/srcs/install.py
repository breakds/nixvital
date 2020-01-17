#!/usr/bin/env python3

# username =
# hostname =
# target = /mnt
# config = choose from

import os
import pathlib
import subprocess
import click
from tabulate import tabulate
from git import Repo
from prompt_toolkit import prompt, print_formatted_text, HTML
from prompt_toolkit.validation import Validator, ValidationError
from prompt_toolkit.completion import WordCompleter
from prompt_toolkit.styles import Style

APP_STYLE = Style.from_dict({
    'prompt_text': '#00aa00 bold',
    'input_target': '#DDA0DD bold underline',
    'ok': 'lightgreen',
    'info': 'skyblue',
})


def GenerateHardwareConfig(install_root):
    pathlib.Path(install_root, 'etc', 'nixos').mkdir(parents=True, exist_ok=True)
    ret = subprocess.run(['nixos-generate-config', '--root', install_root,
                          '--show-hardware-config'], capture_output=True)

    hardware_config = pathlib.Path(install_root, 'etc', 'nixos',
                                   'hardware-configuration.nix')

    with open(hardware_config, 'w') as out:
        out.write(ret.stdout.decode('utf-8'))
        print_formatted_text(HTML(
            'Hardware configuration generated at <green>{}</green>'.format(
                hardware_config)))


def CloneNixvital(install_root):
    # Ensure parent directory
    pathlib.Path(install_root, 'opt').mkdir(parents=True, exist_ok=True)

    # Clone if nixvital is not there yet
    vital_dir = pathlib.Path(install_root, 'opt', 'nixvital')
    if not (vital_dir.exists() and vital_dir.is_dir()):
        repo = Repo.clone_from('https://git.breakds.org/nixvital.git/', vital_dir)
    return vital_dir


def ListOfMachines(vital_dir):
    result = []
    machine_root = pathlib.Path(vital_dir, 'machines')
    for candidate in machine_root.glob('**/*.nix'):
        if candidate.name != 'base.nix':
            result.append(str(candidate.relative_to(machine_root)))
    return result

class CandidateValidator(Validator):
    def __init__(self, candidates):
        self.candidates = candidates

    def validate(self, document):
        if document.text not in self.candidates:
            raise ValidationError(
                message='Input does not match any candidates: {}'.format(self.candidates),
                cursor_position=0)

def PromptFor(property, doc=None, candidates=None, default=''):
    completer = WordCompleter(candidates) if candidates else None
    validator = CandidateValidator(candidates) if candidates else None

    def tips():
        if doc:
            return HTML(doc)
        else:
            return HTML('Please input <b>{}</b>'.format(doc))

    return prompt(
        [
            ('class:prompt_text', 'Please specify '),
            ('class:input_target', property),
            ('', ': ')
        ],
        style=APP_STYLE, completer=completer, validator=validator,
        bottom_toolbar=tips, default=default)


def CreateSymbolicLink(install_root, vital_dir):
    vital_symlink = pathlib.Path(install_root, 'etc/nixos/nixvital')
    vital_symlink.parent.mkdir(parents=True, exist_ok=True)
    if vital_symlink.exists():
        vital_symlink.unlink()
    vital_symlink.symlink_to(pathlib.Path('../../opt/nixvital'))

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


def main():
    # 1. Installation root (default to /mnt)
    install_root = PromptFor('installation root',
                             'Specifies where to install the system.',
                             default='/mnt')

    # 2. Clone the nixvital git repo
    vital_dir = CloneNixvital(install_root)

    # 3. Select a machine
    available_machines = ListOfMachines(vital_dir)
    print('Here is a list of available machine configs.')
    for machine in available_machines:
        print_formatted_text(
            HTML('Machine: <b><skyblue>{}</skyblue></b>'.format(machine)))
    machine = PromptFor('machine config',
                        'The entry point NixOS configuration for the new machine.',
                        candidates=ListOfMachines(vital_dir))

    # 4. Customization: username and hostname
    username = PromptFor('username',
                         'The main user of the installed OS, which has uid = 1000.')
    hostname = PromptFor('hostname',
                         'The hostname of the newly installed machine.')

    # +------------------------------------------------------------+
    # | Install                                                    |
    # +------------------------------------------------------------+

    GenerateHardwareConfig(install_root)
    CreateSymbolicLink(install_root, vital_dir)
    RewriteConfiguration(install_root, username, machine, hostname)


if __name__ == '__main__':
    main()
