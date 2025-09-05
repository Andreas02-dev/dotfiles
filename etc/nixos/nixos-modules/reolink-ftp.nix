{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.services.reolink-ftp = {
    enable = mkEnableOption (mdDoc "reolink FTP server");
  };

  config = mkIf config.services.reolink-ftp.enable {
    services.vsftpd = {
      enable = true;
      writeEnable = true;
      anonymousUser = true;
      anonymousUploadEnable = true;
      anonymousMkdirEnable = true;

      extraConfig = ''
        # --- Anonymous User Directives ---
        anonymous_enable=YES
        anon_upload_enable=YES
        anon_mkdir_write_enable=YES
        anon_umask=002

        # --- CRITICAL PASSIVE MODE SETTINGS ---
        # Explicitly enable passive mode.
        pasv_enable=YES

        # Define the port range for passive data connections.
        # This MUST match the firewall configuration below.
        pasv_min_port=40000
        pasv_max_port=40100
      '';
    };

    # Declaratively create a writable directory for uploads.
    # This is required for `anon_upload_enable` to have any effect.
    systemd.tmpfiles.rules = [
      "d /home/ftp/reolink 0777 ftp nogroup -"
    ];

    networking.firewall = {
      allowedTCPPorts = [21];
      allowedTCPPortRanges = [
        {
          from = 40000;
          to = 40100;
        }
      ];
    };

    users.groups.media = {
      # Force this group's ID to match the one inside the Docker container
      gid = 33;
    };

    users.users.ftp = {
      isSystemUser = true;
      extraGroups = ["media"];
    };

    # --- Reolink Cleanup and Backup Service ---
    systemd.services."reolink-backup-script" = {
      path = [pkgs.rsync pkgs.findutils];
      script = ''
        #!/usr/bin/env bash
        set -e

        # --- Configuration ---
        source_path="/home/ftp/reolink"
        base_backup_path="/var/lib/backups/reolink"
        retention_days=14

        # --- 1. Cleanup Phase ---
        echo "Starting cleanup phase..."

        # Delete source video files older than $retention_days days
        echo "Cleaning up source files in $source_path..."
        find "$source_path" -type f -mtime +$retention_days -delete

        # Run cleanup for empty directories multiple times to remove nested parents (DD, then MM, then YYYY)
        echo "Cleaning up empty date directories..."
        for i in 1 2 3; do
          find "$source_path" -type d -empty -delete
        done

        # Delete entire backup snapshots (YYYYMMDD folders) older than $retention_days days
        echo "Cleaning up old backup snapshots in $base_backup_path..."
        find "$base_backup_path" -type d -maxdepth 1 -mtime +$retention_days -exec rm -rf {} +

        echo "Cleanup finished."

        # --- 2. Backup Phase ---
        echo "Starting Reolink backup..."
        backup_path="$base_backup_path/`date +"%Y%m%d"`"
        mkdir -p "$backup_path"
        rsync -a "$source_path/" "$backup_path/"
        echo "Reolink backup finished!"
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
    };

    # --- Reolink Backup Timer ---
    systemd.timers."reolink-backup-script" = {
      timerConfig = {
        OnCalendar = "*-*-* 3:00:00";
        Persistent = true;
        Unit = "reolink-backup-script.service";
      };
      wantedBy = ["timers.target"];
    };
  };
}
