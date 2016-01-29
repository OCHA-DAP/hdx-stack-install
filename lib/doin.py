"""docker install: setup and configure a docker-compose stack."""

# 2015 copyleft "Serban Teodorescu <teodorescu.serban@gmail.com>"

import fcntl
import getpass
import re
import os
import requests
import socket
import struct
import sys


class Doin(object):
    """encapsulates some dirty logic for configuring a docker stack."""

    version = '0.2'

    def __init__(self, vars_file='vars', var_pattern=['${', '}'],
                 private_vars_separator=':::'):
        """initializer."""
        self.custom_vars = dict()
        self.env = dict()
        self.files_folder = '.files'
        self.private_files = dict()
        self.private_vars_separator = private_vars_separator
        self.var_pattern = var_pattern
        self.vars_file = vars_file
        self.env['DOCKER0_ADDR'] = self.get_ip_address('docker0')
        self.private_repo = dict.fromkeys(['base_url', 'files',
                                           'user', 'pass'])

    @staticmethod
    def get_ip_address(ifname):
        """get the assigned ip address of an interface."""
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        return socket.inet_ntoa(fcntl.ioctl(
            s.fileno(),
            0x8915,  # SIOCGIFADDR
            struct.pack('256s', ifname[:15])
        )[20:24])

    def _file_path(self, file_name):
        return '/'.join([self.files_folder, file_name])

    def _import_file(self, file_name):
        """import a file (e.g. rsa key or certificate into a string."""
        with file(self._file_path(file_name)) as f:
            return f.read().replace('\n', self.private_vars_separator)

    def import_private_files(self):
        """import all private files in self.private_files."""
        for var_name, file_name in self.private_files.items():
            self.env[var_name] = self._import_file(file_name)

    def _configure_remote_repo(self):
        """configure params to be able to connect to a remote repo."""
        if not self.private_repo['base_url']:
            self.private_repo['base_url'] = raw_input('Base url for your repo: ')
        if not self.private_repo['user']:
            self.private_repo['user'] = raw_input('Your repo username: ')
        if not self.private_repo['pass']:
            self.private_repo['pass'] = getpass.getpass('Your repo password: ')

    def fetch_remote_private_file(self, file_name):
        """
        fetch a file from a remote repo and save it locally.

        uses url and credentials from self.private_repo
        """
        if os.path.isfile(self._file_path(file_name)):
            return True
        if not os.path.isdir(self.files_folder):
            os.makedirs(self.files_folder)
        self._configure_remote_repo()
        url = ''.join([self.private_repo['base_url'], file_name])
        user = self.private_repo['user']
        password = self.private_repo['pass']
        try:
            req = requests.get(url, auth=(user, password))
        except requests.exceptions.ConnectionError:
            print 'There was a problem connecting to your repo host.'
            print 'Fetch of', file_name, 'skipped.'
        else:
            if req.status_code == 200:
                with open(self._file_path(file_name), 'w') as f:
                    f.write(req.text)
                return True
            elif req.status_code == 404:
                print 'There was a problem with the url path or file name.'
                print 'Fetch of', file_name, 'skipped.'
            elif req.status_code == 401 or req.status_code == 403:
                print 'There was a problem with your repo credentials.'
                print 'Fetch of', file_name, 'skipped.'
            else:
                print 'There was a problem connecting to your repo.'
                print 'Fetch of', file_name, 'skipped.'
        return False

    def import_remote_private_files(self):
        """import private files from a remote repo."""
        for var_name, file_name in self.private_repo['files']:
            if self.fetch_remote_private_file(file_name):
                self.env[var_name] = self._import_file(file_name)

    def import_vars(self):
        """load vars from vars file, substitution included, into self.env."""
        with file(self.vars_file) as f:
            for l in f.readlines():
                l = l.rstrip()
                if (len(l) < 2) or ('=' not in l) or (l.startswith('#')):
                    continue
                label, value = l.split('=')
                self.env[label] = self.replace_pattern(value)
                # if value matches this pattern: $((something+somethingelse))
                regexp_match = re.match(r'\$\(\(.+\+([0-9]+)\)\)', value)
                if regexp_match:
                    try:
                        port_inc = regexp_match.group(1)
                    except IndexError:
                        print 'Error trying to set the port number for:', label
                    else:
                        # i don't like hardconding baseport key name
                        value = int(self.env['HDX_BASEPORT']) + int(port_inc)
                        self.env[label] = str(value)
                # custom vars (a variable deduced from another)
                if label in self.custom_vars:
                    name, regex, subst = self.custom_vars[label]
                    self.env[name] = re.sub(regex, subst, value)

    def apply_template(self, template_file):
        """
        write a config file from template and self.env.

        assumes the template file ends with '.tpl'.
        """
        file_name = re.sub(r'\.tpl$', '', template_file)
        with open(template_file) as t:
            template = t.readlines()
        with open(file_name, 'w') as f:
            for line in template:
                f.write(self.replace_pattern(line))

    def replace_pattern(self, text):
        """replace patterns in input with their respective self.env values."""
        sub_vars = re.findall(r'\$\{([0-9a-zA-Z_]+)\}', text.rstrip())
        for v in sub_vars:
            if v not in self.env:
                self.env[v] = ''
            if self.env[v] is None:
                self.env[v] = ''
            var_pattern = list(self.var_pattern)
            var_pattern.insert(1, v)
            text = text.replace(''.join(var_pattern), self.env[v])
        return text

    def create_config_files(self):
        """create config files from self.env and templates."""
        template_locations = ['.', 'envs']
        my_abs_path = os.path.dirname(os.path.abspath(__file__))
        for template_location in template_locations:
            for template_file in os.listdir(template_location):
                template_file = os.path.join(my_abs_path,
                                             template_location,
                                             template_file)
                if not template_file.endswith('.tpl'):
                    continue
                self.apply_template(template_file)


def main():
    """main routine."""
    c = Doin()
    # example: right after you import the variable named HDX_PREFIX,
    # create another variable named HDX_SHORT_PERFIX; the value of this new one
    # is computed by replacing <regex> with <subst> in HDX_PREFIX value
    c.custom_vars = {
        'HDX_PREFIX': ('HDX_SHORT_PREFIX', r'-$', ''),
        'DOMAIN': ('DOMAIN_LABEL', r'\.ro$', 'ro')
    }
    # details about your repo
    c.private_repo = {
        'base_url': 'https://bitbucket.org/teodorescuserban/hdx-install-private/raw/master/',
        'user': 'hdx-user',
        'pass': False,
        'files': [['HDX_SSL_CRT', 'ssl.crt'],
                  ['HDX_SSL_KEY', 'ssl.key'],
                  ['HDX_SSH_PUB', 'ssh.crt'],
                  ['HDX_SSH_KEY', 'ssh.key'],
                  ['HDX_DKIM_CRT', 'dkim.crt'],
                  ['HDX_DKIM_KEY', 'dkim.key'],
                  ['HDX_NGINX_PASS', 'nginx.pass']]
    }
    c.import_remote_private_files()
    c.import_vars()
    c.create_config_files()


if __name__ == '__main__':
    sys.exit(main())
