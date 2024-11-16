# Ansible playbooks

This is a repo of playbooks and inventory for my home lab. If you're reading this then I am not sure why you are here.

## Development
These should be run on the Ansible controller. In my case, a Windows WSL deployment on Ubuntu
Create a new SSH key if needed: `ssh-keygen`

```
pip3 install virtualenv
virtualenv ~/venvs/default
apt install sshpass
pip install -r requirements.txt
ansible-galaxy install -r ansible-requirements.yml
```
 
## Deployment
Initial setup of a new system:
```
ansible -i inventory/lab 192.168.86.64 -m setup -k
ansible-playbook -Kk -i inventory/lab/ site.yml -e "install_ssh_keys=yes"
```
Subsequent application of playbooks using SSH keys: `ansible-playbook -K -i inventory/lab/ site.yml`