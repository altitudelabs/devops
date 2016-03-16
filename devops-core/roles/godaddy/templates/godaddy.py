from pygodaddy import GoDaddyClient
import sys

username = sys.argv[1]
password = sys.argv[2]

client = GoDaddyClient()
if client.login(username, password):
    print client.find_domains()
    client.update_dns_record('{{ item }}', '{{ inventory_hostname }}')
