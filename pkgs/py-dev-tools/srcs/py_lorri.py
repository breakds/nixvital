#!/usr/bin/env python3

import os
import stat
import shutil
import pathlib
import subprocess
import click
from prompt_toolkit import print_formatted_text, HTML
from prompt_toolkit.shortcuts import radiolist_dialog


class Logger(object):

    @staticmethod
    def Ok(message):
        print_formatted_text(HTML('[<green> ok </green>] {}'.format(message)))

    @staticmethod
    def Warn(message):
        print_formatted_text(HTML('[<orange>WARN</orange>] {}'.format(message)))


def CopyDirectory(source, target, permission):
    # Remove the target directory if it exists
    if target.exists() and target.is_dir():
        shutil.rmtree(target)
    
    shutil.copytree(source, target)

    # Set the right permission
    for node, children, files in os.walk(target):
        os.chmod(node, permission | stat.S_IEXEC | stat.S_IXGRP | stat.S_IXOTH)
        for f in files:
            os.chmod(pathlib.Path(node, f), permission)

def GenerateShellNix(shell_library, target_dir):
    permission = (stat.S_IRUSR | stat.S_IWUSR | stat.S_IRGRP | stat.S_IROTH)

    # shell.nix
    source_shell_nix = pathlib.Path(shell_library, 'shell.nix')
    target_shell_nix = pathlib.Path(target_dir, 'shell.nix')
    shutil.copy(str(source_shell_nix), str(target_shell_nix))
    os.chmod(target_shell_nix, permission)

    # Copy shell.d
    source_shell_d = pathlib.Path(shell_library, 'shell.d')
    target_shell_d = pathlib.Path(target_dir, '.shell.d')
    CopyDirectory(source_shell_d, target_shell_d, permission)    
    
    
def GenerateLorriFiles(shell_library):
    target_dir = os.getcwd()

    GenerateShellNix(shell_library, target_dir)

    envrc = pathlib.Path(target_dir, '.envrc')
    if envrc.exists():
        Logger.Warn('<u>.envrc</u> exists, overriding.')
    with open(envrc, 'w') as out:
        out.write('eval "$(lorri direnv)"\n')
    Logger.Ok('.envrc generated.')

    subprocess.run(['direnv', 'allow'])

    Logger.Ok('Python dev env established.')

@click.command()
@click.option('--shell_library', required=True,
              type=click.Path(exists=True, file_okay=False, dir_okay=True,
                              writable=False, readable=True))
def main(shell_library):
    GenerateLorriFiles(shell_library)

if __name__ == '__main__':
    main()
