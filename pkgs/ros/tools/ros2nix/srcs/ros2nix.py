#!/usr/bin/env python3

import os
import click
import yaml
import re
import subprocess
import pathlib

from prompt_toolkit import prompt, print_formatted_text, HTML
from prompt_toolkit.validation import Validator, ValidationError
from prompt_toolkit.completion import WordCompleter
from prompt_toolkit.styles import Style


APP_STYLE = Style.from_dict({
    'prompt_text': '#00aa00 bold',
    'ok': 'lightgreen',
    'info': 'skyblue',
    'fail': 'red',
})


class Logger(object):

    @staticmethod
    def Ok(message):
        print_formatted_text(HTML('[<ok> ok </ok>] {}'.format(message)), style=APP_STYLE)

    @staticmethod
    def Warn(message):
        print_formatted_text(HTML('[<warn>WARN</warn>] {}'.format(message)), style=APP_STYLE)

    @staticmethod
    def Fail(message):
        print_formatted_text(HTML('[<fail>WARN</fail>] {}'.format(message)), style=APP_STYLE)
    

def GetPname(name):
    return name.split(r'http(.*)')[-1]


URI_PATTERN=re.compile('https://github.com/([^/]*)/([^/]*)/archive/release/([^/]*)/([^/]*)/([^/-]*)-(.*)\.tar\.gz')

def ParseURI(uri):
    m = URI_PATTERN.fullmatch(uri)
    # Returns (owner, repo, distro, pname, version, subversion)
    return m.group(1), m.group(2), m.group(3), m.group(4), m.group(5), m.group(6)

# print(ParseURI('https://github.com/ros-gbp/ros-release/archive/release/kinetic/ros/1.14.6-1.tar.gz'))

class PackageItem(object):
    def __init__(self, yaml_item):
        self.name = yaml_item['tar']['local-name']
        self.uri = yaml_item['tar']['uri']
        owner, repo, distro, pname, version, subversion = ParseURI(self.uri)
        self.owner = owner
        self.repo = repo
        self.distro = distro
        self.pname = pname
        self.version = version
        self.subversion = subversion

    def __repr__(self):
        return '[{} {}] - {}\n  pname: {}\n  distro: {}'.format(self.pname, self.version, self.uri, self.pname, self.distro)


class CandidateValidator(Validator):
    def __init__(self, candidates):
        self.candidates = candidates
        
    def validate(self, document):
        if document.text not in self.candidates:
            raise ValidationError(
                message='Input does not match any candidates: {}'.format(self.candidates),
                cursor_position=0)


def PromptForPackageName(all_modules):
    completer = WordCompleter(all_modules.keys())
    validator = CandidateValidator(all_modules.keys())

    return prompt(
        [
            ('class:prompt_text', 'Please specify ROS module/package: '),
            ('', ': ')
        ],
        style=APP_STYLE, completer=completer, validator=validator)


def GenerateNixFile(directory, package, sha256):
    package_dir = pathlib.Path(directory, package.pname)
    package_dir.mkdir(parents=True, exist_ok=True)
    config_path = pathlib.Path(package_dir, 'default.nix')

    with open(config_path, 'w') as out:
        out.write('{ stdenv, buildRosPackage, fetchFromGitHub }:\n')
        out.write('\n')
        out.write('let pname = "{}";\n'.format(package.pname))
        out.write('    version = "{}";\n'.format(package.version))
        out.write('    subversion = "{}";\n'.format(package.subversion))
        out.write('    rosdistro = "{}";\n'.format(package.distro))
        out.write('\n')
        out.write('in buildRosPackage {\n')
        out.write('  name = "${pname}-${version}";\n')
        out.write('\n')
        out.write('  propagatedBuildInputs  = [];\n')
        out.write('\n')
        out.write('  src = fetchFromGitHub {\n')
        out.write('    owner = "{}";\n'.format(package.owner))
        out.write('    repo = "{}";\n'.format(package.repo))
        out.write('    rev = "release/${rosdistro}/${pname}/${version}-${subversion}";\n')
        out.write('    sha256 = "{}";\n'.format(sha256))
        out.write('  };\n')
        out.write('\n')
        out.write('  meta = {\n')
        out.write('    description = "{}";\n'.format(package.pname))
        out.write('    homepage = http://wiki.ros.org/{};\n'.format(package.pname))
        out.write('    license = stdenv.lib.licenses.bsd3;\n')
        out.write('  };\n')
        out.write('}\n')


@click.command()
@click.option('--package_list', required=True,
              type=click.Path(exists=True, file_okay=True, dir_okay=False,
                              writable=False, readable=True))
def main(package_list):
    all_modules = {}

    with open(package_list, 'r') as f:
        for item in yaml.safe_load(f):
            package = PackageItem(item)
            all_modules[package.pname] = package

    package_name = PromptForPackageName(all_modules)

    if package_name not in all_modules:
        Logger.Fail('{} is not a valid package.'.foramt(package_name))

    package = all_modules[package_name]
    print(package)

    ret = subprocess.run(['nix-prefetch-url', '--unpack', package.uri], capture_output=True)

    if ret.returncode is not 0:
        Logger.Fail('Failed to get the sha256 of {}'.format(package_name))
        return

    sha256 = ret.stdout.decode('ascii').strip()

    GenerateNixFile(os.getcwd(), package, sha256)

    Logger.Ok('{}/default.nix generated.'.format(package_name))
    


if __name__ == '__main__':
    main()
