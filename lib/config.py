"""setup and configure a docker-compose stack."""

# 2015 copyleft "Serban Teodorescu <teodorescu.serban@gmail.com>"

import imp
import sys

HELPER_PATH = 'docohelper.py'


def main():
    """main."""
    doco = imp.load_source('docohelper', HELPER_PATH)
    # configuring a docker-compose setup.
    c = doco.DockerHelper.fromhost(templates_root_path='.')

    c.custom_vars = {
        'HDX_PREFIX': ('HDX_SHORT_PREFIX', r'-$', ''),
        'DOMAIN': ('DOMAIN_LABEL', r'\.ro$', 'ro')
    }
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
    c.fetch_remote_private_file('set_private_vars')
    c.vars_file = '.files/set_private_vars'
    c.import_vars()
    c.create_config_files()

if __name__ == '__main__':
    sys.exit(main())
