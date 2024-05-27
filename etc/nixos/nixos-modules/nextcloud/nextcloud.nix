{
  pkgs
  , inputs
  , config
  , ...
}: {
  
  users.groups.nextcloud = { };
  users.users.nextcloud = {
    isSystemUser = true;
    group = "nextcloud";
  };

  services.nextcloud = {
    enable = true;
    https = true;
    home = "/var/lib/nextcloud";
    logType = "file";
    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "16G";
    autoUpdateApps.enable = true;
    package = pkgs.nextcloud29;
    hostName = "nexxtcloud.onthewifi.com";
    config = {
      adminpassFile = "/etc/nextcloud/nextcloud-admin-pass";
      overwriteProtocol = "https";
      defaultPhoneRegion = "NL";
      dbtype = "mysql"; # Uses MariaDB under the hood
      trustedProxies = [ "127.0.0.1" ];
    };
    phpOptions."opcache.interned_strings_buffer" = "32";
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit calendar contacts mail notes onlyoffice spreed impersonate;

        groupfolders = pkgs.fetchNextcloudApp rec {
          url =
            "https://github.com/nextcloud-releases/groupfolders/releases/download/v17.0.0/groupfolders-v17.0.0.tar.gz";
          sha256 = "sha256-ut56wU4WVmuU7XecueP6ojB9yZH7GnTUzQg1XNoq5vQ=";
          license = "agpl3";
        };

        drawio = pkgs.fetchNextcloudApp rec {
          url =
            "https://github.com/jgraph/drawio-nextcloud/releases/download/v3.0.2/drawio-v3.0.2.tar.gz";
          sha256 = "sha256-GSLynpuodzjjCy272eksudRJj2WlHwq4OntCGHad4/U=";
          license = "agpl3";
        };

    };
    extraAppsEnable = true;
    extraOptions = {
      overwritehost = "nexxtcloud.onthewifi.com";
      overwriteprotocol = "https";
      allow_local_remote_servers = true;
      maintenance_window_start = 4;
      trusted_domains = [ "nexxtcloud.onthewifi.com" ];
    };
  };

  services.nginx.virtualHosts."${config.services.nextcloud.hostName}" = {
    forceSSL = true;
    enableACME = true;
  };

  security.acme = {
    acceptTerms = true;   
    certs = { 
      ${config.services.nextcloud.hostName}.email = "andreashoornstra@gmail.com"; 
    }; 
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

}
