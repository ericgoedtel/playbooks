# virtualization.nix
#
# This module configures the virtualization configuration
{
  config,
  pkgs,
  lib,
  ...
}: {
  virtualisation = {
    libvirtd.enable = true;
    lxc.enable = true;
    docker.enable = true;
  };

  services.localstack = {
    enable = true;
    hostname = "localstack.pilothouse.takamagahara.lan";
    services = ["s3" "lambda" "dynamodb" "cloudformation" "sts" "iam"];
    openFirewall = true;
    enableCaddy = true;
  };

  boot = {
    extraModprobeConfig = ''      # enable nested virtualization for Intel CPUs
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
    '';
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.bridge.bridge-nf-call-iptables" = 1;
    };
    kernelModules = ["br_netfilter"];
  };
}
