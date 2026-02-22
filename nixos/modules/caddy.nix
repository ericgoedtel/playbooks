_: {
  services.caddy = {
    enable = true;
    extraConfig = ''
      :80 {
        # Route /ntopng/* to the ntopng service
        redir /ntopng /ntopng/
        handle_path /ntopng/* {
          reverse_proxy localhost:3000
        }

        # Example: Route another tool later
        # handle_path /payloads/* {
        #   reverse_proxy localhost:8080
        # }

        # Optional: A simple landing page at the root
        handle / {
            respond "One ping only, please"
        }
      }
    '';
  };

  # Open standard HTTP port
  networking.firewall.allowedTCPPorts = [80];
}
