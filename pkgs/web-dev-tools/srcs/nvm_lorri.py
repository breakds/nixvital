#!/usr/bin/env python3

import os
import pathlib
import subprocess
from prompt_toolkit import print_formatted_text, HTML
from prompt_toolkit.shortcuts import radiolist_dialog


class Logger(object):

    @staticmethod
    def Ok(message):
        print_formatted_text(HTML('[<green> ok </green>] {}'.format(message)))

    @staticmethod
    def Warn(message):
        print_formatted_text(HTML('[<orange>WARN</orange>] {}'.format(message)))


def SelectVersion(versions):
    version_select_items = []

    # TODO(breakds): Read the current version from shell.nix if it exists.
    for label, version in versions:
        version_select_items.append(
            (version, HTML('Node.js <green>{}</green>'.format(label))))

    return radiolist_dialog(
        values=version_select_items,
        title=HTML('Select <skyblue>Node.js</skyblue> Version'),
        text='Available versions are')


def GenerateLorriFiles(version):
    target_dir = os.getcwd()

    shell_nix = pathlib.Path(target_dir, 'shell.nix')
    if shell_nix.exists():
        Logger.Warn('<u>shell.nix</u> exists, overriding.')
    with open(shell_nix, 'w') as out:
        out.write('let\n')
        out.write('  pkgs = import <nixpkgs> {};\n')
        out.write('  nodejs-pinned = pkgs.nodejs-{};\n'.format(version))
        out.write('in\n')
        out.write('  pkgs.mkShell {\n')
        out.write('    buildInputs = with pkgs; [\n')
        out.write('        nodejs-pinned\n')
        out.write('        (yarn.override { nodejs = nodejs-pinned; })\n')
        out.write('    ];\n')
        out.write('    shellHook = \'\'\n')
        out.write('      export PATH="${toString ./node_modules/.bin}:$PATH"\n')
        out.write('    \'\';\n')
        out.write('  }\n')
    Logger.Ok('shell.nix generated.')

    envrc = pathlib.Path(target_dir, '.envrc')
    if envrc.exists():
        Logger.Warn('<u>.envrc</u> exists, overriding.')
    with open(envrc, 'w') as out:
        out.write('eval "$(lorri direnv)"\n')
    Logger.Ok('.envrc generated.')

    subprocess.run(['direnv', 'allow'])

    Logger.Ok('NodeJs version set to {}'.format(version))


def main():
    version = SelectVersion([
        ('10.x', '10_x'),
        ('12.x', '12_x'),
    ])

    if version is None:
        Logger.Ok('Operation <b>cancelled</b>, <skyblue>nothing</skyblue> has beeng changed.')
        return

    GenerateLorriFiles(version)

if __name__ == '__main__':
    main()
