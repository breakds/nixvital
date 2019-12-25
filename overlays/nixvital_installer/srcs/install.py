#!/usr/bin/env python

import click
from clint.textui import puts, colored, indent
from tabulate import tabulate

@click.command()
@click.option('--install-root', default='/mnt')
def main(install_root):

    cwd = '/tmp'

    table = [['install root', install_root],
             ['working dir', cwd]]

    print(tabulate(table, headers=['Property', 'Value'], tablefmt='grid'))
    
    puts(colored.green('Installed to {}!'.format(install_root)))

if __name__ == '__main__':
    main();
