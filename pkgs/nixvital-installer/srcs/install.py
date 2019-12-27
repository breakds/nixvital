#!/usr/bin/env python3

# username =
# hostname =
# target = /mnt
# config = choose from

import os
import click
from clint.textui import puts, colored, indent
from tabulate import tabulate
from git import Repo

from prompt_toolkit.application.current import get_app
from prompt_toolkit import Application, PromptSession, prompt, print_formatted_text, HTML
from prompt_toolkit.styles import Style
from prompt_toolkit.buffer import Buffer
from prompt_toolkit.layout.containers import FloatContainer, Float, HSplit, VSplit, Window
from prompt_toolkit.layout.controls import BufferControl, FormattedTextControl
from prompt_toolkit.layout.layout import Layout
from prompt_toolkit.widgets import RadioList, Button, Frame, Label, Box, TextArea
from prompt_toolkit.layout.dimension import D
from prompt_toolkit.shortcuts import message_dialog, input_dialog

# For handling key bindings
from prompt_toolkit.key_binding import KeyBindings
from prompt_toolkit.key_binding.bindings import focus

APP_STYLE = Style.from_dict({
    'ok': 'lightgreen',
    'info': 'skyblue',
})

def CloneNixvital(cwd):
    target_dir = os.path.join(cwd, 'nixvital')
    repo = Repo.clone_from('https://git.breakds.org/nixvital.git/', target_dir)
    print(repo)


def OnExit():
    get_app().exit()

def OnInstall():
    text = input_dialog(
        title='Input dialog example',
        text='Please type your name:')

class InstallerApp(object):
    def __init__(self):
        self.install_button = Button(text="Install", handler=OnInstall)
        self.exit_button = Button(text="Exit", handler=OnExit)

        self.config_items = RadioList(
            values = [
                ("user", "breakds"),
                ("target", "/tmp"),
            ]
        )
        
        self.kb = KeyBindings()
        self.kb.add("tab")(focus.focus_next)

        @self.kb.add("c-c")
        @self.kb.add("c-q")
        def _(event):
            event.app.exit()

        self.input_field = TextArea(
            height=1,
            prompt=">>> ",
            multiline=False,
            wrap_lines=False,
        )

        self.editor = Frame(title="Configurations", body=HSplit([
            self.input_field,
            self.input_field
        ]), height=D())

        self.app = Application(
            layout=Layout(HSplit([
                Window(content=self.editor),
                Box(body=VSplit([self.install_button, self.exit_button],
                                align="CENTER", padding=3),
                    height=3)
            ])),
            key_bindings=self.kb,
            mouse_support=True,
            full_screen=True)

    def Run(self):
        self.app.run()
            

@click.command()
@click.option('--install-root', default='/mnt')
def main(install_root):
    cwd = '/tmp'
    # CloneNixvital(cwd)

    table = [['install root', install_root],
             ['working dir', cwd]]

    # puts(colored.green('Installed to {}!'.format(install_root)))

    # print_formatted_text('Hello!')
    # print_formatted_text(HTML('<b>Hello!</b>'))
    # print_formatted_text(HTML('<skyblue>This is sky blue</skyblue>'))
    # print_formatted_text(HTML('<ok>This is sky blue</ok>'), style=APP_STYLE)

    # session = PromptSession()

    # text = session.prompt('What is 2 + 3')
    # print('It is {}'.format(text))
    installer = InstallerApp()
    print(dir(installer.input_field))
    installer.Run()

if __name__ == '__main__':
    main();
