#!/usr/bin/env python3

# username =
# hostname =
# target = /mnt
# config = choose from

import os
import click
from tabulate import tabulate
from git import Repo
from prompt_toolkit import prompt, HTML
from prompt_toolkit.styles import Style

APP_STYLE = Style.from_dict({
    'prompt_text': '#00aa00 bold',
    'input_target': '#4466aa bold underline',
    'ok': 'lightgreen',
    'info': 'skyblue',
})

def CloneNixvital(cwd):
    target_dir = os.path.join(cwd, 'nixvital')
    repo = Repo.clone_from('https://git.breakds.org/nixvital.git/', target_dir)
    print(repo)

def PromptFor(property):
    return prompt([
        ('class:prompt_text', 'Please specify '),
        ('class:input_target', property),
        ('', ': ')
    ], style=APP_STYLE)

@click.command()
@click.option('--install-root', default='/mnt')
def main(install_root):
    cwd = '/tmp'
    # CloneNixvital(cwd)

    table = [['install root', install_root],
             ['working dir', cwd]]

    # Get username
    username = PromptFor('username')
    print('You entered {}'.format(username))

    



if __name__ == '__main__':
    main();
