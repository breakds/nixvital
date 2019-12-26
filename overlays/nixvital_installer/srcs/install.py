#!/usr/bin/env python3

import os
import click
from clint.textui import puts, colored, indent
from tabulate import tabulate
from git import Repo
from prompt_toolkit import Application, PromptSession, prompt, print_formatted_text, HTML
from prompt_toolkit.styles import Style

APP_STYLE = Style.from_dict({
    'ok': 'lightgreen',
    'info': 'skyblue',
})

def CloneNixvital(cwd):
    target_dir = os.path.join(cwd, 'nixvital')
    repo = Repo.clone_from('https://git.breakds.org/nixvital.git/', target_dir)
    print(repo)
    

@click.command()
@click.option('--install-root', default='/mnt')
def main(install_root):
    # cwd = '/tmp'
    # CloneNixvital(cwd)

    # table = [['install root', install_root],
    #          ['working dir', cwd]]

    # print(tabulate(table, headers=['Property', 'Value'], tablefmt='grid'))
    
    # puts(colored.green('Installed to {}!'.format(install_root)))

    # print_formatted_text('Hello!')
    # print_formatted_text(HTML('<b>Hello!</b>'))
    # print_formatted_text(HTML('<skyblue>This is sky blue</skyblue>'))
    # print_formatted_text(HTML('<ok>This is sky blue</ok>'), style=APP_STYLE)

    # session = PromptSession()

    # text = session.prompt('What is 2 + 3')
    # print('It is {}'.format(text))

    app = Application(full_screen=True)
    app.run()

    

if __name__ == '__main__':
    main();
