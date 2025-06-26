{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    nixpkgs.hostPlatform = "x86_64-linux";
    system-manager.allowAnyDistro = true;

    systemd.services = {
      tailscaled = {
        enable = true;
        description = "Tailscale Oneshot";
        wantedBy = ["graphical-session.target" "system-manager.target"];
        unitConfig = {
          Wants = ["network-online.target"];
          After = ["network-online.target" "NetworkManager.service" "systemd-resolved.service"];
        };
        serviceConfig = {
          ExecStart = "${pkgs.tailscale}/bin/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/run/tailscale/tailscaled.sock  --port=41641";
          Type = "simple";
          RuntimeDirectory = "tailscale";
          RuntimeDirectoryMode = "0755";
          StateDirectory = "tailscale";
          StateDirectoryMode = "0700";
          CacheDirectory = "tailscale";
          CacheDirectoryMode = "0750";
          Restart = "always";
        };
      };
    };
  };
}
