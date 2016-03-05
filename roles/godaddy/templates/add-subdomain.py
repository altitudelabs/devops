from pygodaddy import GoDaddyClient
client = GoDaddyClient()
if client.login('{{ godaddy_username }}', '{{ godaddy_password }}'):
    print client.find_domains()
    client.update_dns_record('{{ nginx_server_name }}', '{{ public_ip }}')
