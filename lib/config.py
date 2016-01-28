"""setup and configure a docker-compose stack."""

# 2015 copyleft "Serban Teodorescu <teodorescu.serban@gmail.com>"

import sys
import doin


def main():
    """main."""
    doin.main()
    # c = doin.Doin()
    # # example: right after you import the variable named HDX_PREFIX,
    # # create another variable named HDX_SHORT_PERFIX; the value of this new one
    # # is computed by replacing <regex> with <subst> in HDX_PREFIX value
    # c.custom_vars = {
    #     'HDX_PREFIX': ('HDX_SHORT_PREFIX', r'-$', ''),
    #     'DOMAIN': ('DOMAIN_LABEL', r'\.ro$', 'ro')
    # }
    # # where are your private files located and what are the variable names
    # # you want to assign to the resulting imported string
    # c.private_files = {
    #     'HDX_SSL_CRT': '_example_crt.pem',
    #     'HDX_SSL_KEY': '_example_key.pem',
    #     # 'SSH_PUB_KEY': 'ssh.pub',
    #     # 'SSH_KEY': 'ssh.key',
    # }

    # c.import_private_files()
    # c.import_vars()
    # c.create_config_files()

if __name__ == '__main__':
    sys.exit(main())
