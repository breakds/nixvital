#!/usr/bin/env python3

import os
import pathlib
import subprocess
from prompt_toolkit import print_formatted_text, HTML

class Logger(object):

    @staticmethod
    def Ok(message):
        print_formatted_text(HTML('[<green> ok </green>] {}'.format(message)))

    @staticmethod
    def Warn(message):
        print_formatted_text(HTML('[<orange>WARN</orange>] {}'.format(message)))


def main():
    target_dir = os.getcwd()

    shell_nix = pathlib.Path(target_dir, 'shell.nix')
    if shell_nix.exists():
        Logger.Warn('<u>shell.nix</u> exists, leaving it untouched.')
    else:
        with open(shell_nix, 'w') as out:
            out.write('let\n')
            out.write ('  pkgs = import <nixpkgs> {};\n')
            out.write('in\n')
            out.write('  pkgs.mkShell {\n')
            out.write('    buildInputs = with pkgs; [\n')
            out.write('        nodejs-12_x yarn\n')
            out.write('    ];\n')
            out.write('    shellHook = ''\n')
            out.write('      export PATH="${toString ./node_modules/.bin}:$PATH"\n')
            out.write('    '';\n')
            out.write('  }\n')
        Logger.Ok('shell.nix generated.')

    envrc = pathlib.Path(target_dir, '.envrc')
    if envrc.exists():
        Logger.Warn('<u>.envrc</u> exists, leaving it untouched.')
    else:
        with open(envrc, 'w') as out:
            out.write('eval "$(lorri direnv)"\n')
        Logger.Ok('.envrc generated.')

    subprocess.run(['direnv', 'allow'])

    

if __name__ == '__main__':
    main()
