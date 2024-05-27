# First time setup

nextcloud-occ config:app:set onlyoffice DocumentServerInternalUrl --value https://onlyoffice.onthewifi.com/;
nextcloud-occ config:app:set onlyoffice DocumentServerUrl --value https://onlyoffice.onthewifi.com/;
nextcloud-occ config:app:set onlyoffice StorageUrl --value https://nexxtcloud.onthewifi.com/;
nextcloud-occ config:app:set onlyoffice jwt_secret --value {secret}
