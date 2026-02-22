{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.localstack;
in {
  options.services.localstack = {
    enable = mkEnableOption "LocalStack";

    services = mkOption {
      type = types.listOf types.str;
      default = ["s3" "lambda" "dynamodb" "cloudformation" "sts" "iam"];
      description = "List of AWS services to emulate.";
    };

    hostname = mkOption {
      type = types.str;
      default = "localstack.localhost";
      description = "Hostname to use for the LocalStack service (e.g. for Caddy ingress).";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for LocalStack ports.";
    };

    enableCaddy = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to automatically configure Caddy as a reverse proxy.";
    };
  };

  config = mkIf cfg.enable {
    # Ensure Docker is enabled
    virtualisation.docker.enable = true;

    virtualisation.oci-containers.containers.localstack = {
      image = "localstack/localstack";
      autoStart = true;
      ports = ["4566:4566"];
      environment = {
        SERVICES = concatStringsSep "," cfg.services;
        DEBUG = "1";
        DOCKER_HOST = "unix:///var/run/docker.sock";
        HOSTNAME_EXTERNAL =
          if hasPrefix "*." cfg.hostname
          then substring 2 (stringLength cfg.hostname - 2) cfg.hostname
          else cfg.hostname;
      };
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
      ];
      # LocalStack often needs privileged mode for Dind/networking
      extraOptions = ["--privileged"];
    };

    # Caddy integration
    services.caddy.virtualHosts."http://${cfg.hostname}" = mkIf cfg.enableCaddy {
      extraConfig = ''
        reverse_proxy localhost:4566
      '';
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [4566];
  };
}
