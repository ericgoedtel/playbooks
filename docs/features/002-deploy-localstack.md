# Feature Spec: Localstack for intentional misconfiguration

## 1. Goal
Deploy `localstack` to enable a security researcher to explore intentional misconfigurations of common cloud assets.

## 2. System Context
The host is built using NixOS for declarative configuration.
Caddy is configured in a nixos "module" for exposing the individual services
Issuance of TLS certificates is not currently available
Generation of key material for TLS is not currently available
There is a virtual bridge on the system (guests) which blue team tools will use to snoop

## 3. Functional Requirements
1. Use the Docker implementation of localstack. Prefer a docker-compose mechanism.
2. Allow for easy enabling of new localstack sub-systems within the configuration 
3. Expose localstack via Caddy with support for a sub-subdomain to isolate traffic
4. Leverage the existing bridge interface to allow tools to watch traffic
5. Create a configuration framework for definining misconfigured systems declaractively
6. Separate the installation of localstack as a module from the configuration of systems

## 4. Success criteria
1. Simulated attacker system on an external host is able to access the localstack install
2. The traffic to localstack can be inspected via tcpdump
