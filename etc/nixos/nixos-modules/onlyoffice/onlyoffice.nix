{
  pkgs
  , inputs
  , config
  , ...
}: {

  services.onlyoffice = {
    enable = true;
    hostname = "onlyoffice.onthewifi.com";
    jwtSecretFile = "/etc/onlyoffice/onlyoffice-jwt-secret";
  };

  services.nginx.virtualHosts."${config.services.onlyoffice.hostname}" = {
    forceSSL = true;
    enableACME = true;
  };

  security.acme = {
    acceptTerms = true;   
    certs = { 
      ${config.services.onlyoffice.hostname}.email = "andreashoornstra@gmail.com"; 
    }; 
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

}
