"""docker install: setup and configure a docker-compose stack."""

# 2015 copyleft "Serban Teodorescu <teodorescu.serban@gmail.com>"

import fcntl
import re
import os
import socket
import struct
import sys


class Doin(object):
    """encapsulates some dirty logic for configuring a docker stack."""

    version = '0.1'

    def __init__(self, vars_file='vars', var_pattern=['${', '}'],
                 private_vars_separator=':::'):
        """initializer."""
        self.custom_vars = dict()
        self.private_files = dict()
        self.env = dict()
        self.vars_file = vars_file
        self.var_pattern = var_pattern
        self.private_vars_separator = private_vars_separator
        self.env['DOCKER0_ADDR'] = self.get_ip_address('docker0')

    @staticmethod
    def get_ip_address(ifname):
        """get the assigned ip address of an interface."""
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        return socket.inet_ntoa(fcntl.ioctl(
            s.fileno(),
            0x8915,  # SIOCGIFADDR
            struct.pack('256s', ifname[:15])
        )[20:24])

    def _import_file(self, file_name):
        """import a file (e.g. rsa key or certificate into a string."""
        return_list = list()
        try:
            with file(file_name) as f:
                for line in f.readlines():
                    # if '-----' in line:
                    #     continue
                    return_list.append(line.rstrip())
        except IOError:
            print 'File not found or inaccessible:', file_name
            return ''
        return '"' + self.private_vars_separator.join(return_list) + '"'

    def import_private_files(self):
        """import all private files in self.private-files."""
        for var_name, file_name in self.private_files.items():
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
                        port_inc =  regexp_match.group(1)
                    except IndexError:
                        print 'Error trying to determine the port number for:', label
                    else:
                        # i don't like hardconding baseport key name
                        value = self.env['HDX_BASEPORT'] + port_inc
                        self.env[label] = value
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
                print template_file
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
    # where are your private files located and what are the variable names
    # you want to assign to the resulting imported string
    c.private_files = {
        'HDX_SSL_CRT': '_example_crt.pem',
        'HDX_SSL_KEY': '_example_key.pem',
        # 'SSH_PUB_KEY': 'ssh.pub',
        # 'SSH_KEY': 'ssh.key',
    }

    c.import_private_files()
    c.import_vars()
    c.create_config_files()


if __name__ == '__main__':
    sys.exit(main())
