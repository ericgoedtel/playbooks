# Ansible playbooks

This is a repo of playbooks and inventory for my home lab. If you're reading this then I am not sure why you are here.

## Development
These should be run on the Ansible controller.

Create a new SSH key if needed: `ssh-keygen`

```
python3 -m pip install virtualenv
python3 -m virtualenv ~/venvs/default
source ~/venvs/default/bin/activate
pip install -r requirements.txt
ansible-galaxy install -r ansible-requirements.yml
apt install sshpass
```
 
## Deployment
Initial setup of a new system:
```
ansible -i inventory/lab <ansible_hostname> -m setup -k
ansible-playbook -Kk -i inventory/<environment>/ <playbook>.yml -e "install_ssh_keys=yes"
```
Subsequent application of playbooks using SSH keys: `ansible-playbook -K -i inventory/lab/ site.yml`

# Nix Flakes

Right now, there is only one host. But there may be others as I decide to migrate from Ansible to NixOS or Nix pkgs.

## Development
`nix develop` to get a local devShell and do things in the context of the Nix environment. From there, do all the dev work in that context. Pre-commit stuff will not work without it:
```
nix fmt
git commit -m "foo"
statix check
deadnix .
```

To deploy, ensure that the build host is the box itself to avoid trust concerns.
```
git add .
nix run nixpkgs#nixos-rebuild -- switch \                 
  --flake .#flake-name \
  --target-host user@host \
  --build-host user@host --use-remote-sudo
```
