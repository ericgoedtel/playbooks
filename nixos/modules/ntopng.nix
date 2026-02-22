{pkgs, ...}: {
  services.ntopng = {
    enable = true;
    interfaces = ["guests"];
    extraConfig = ''
      --http-port=:3000
      --http-prefix=/ntopng
    '';
  };
}
