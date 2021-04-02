# UMA NESE Backup Script #

This is a set of scripts to facilitate incremental backups to the NESE storage.

### Instructions ###
1. Clone the repo
2. `cp config.sh.example config.sh` and modify values to suite your environment
3. Add the correct SSH key relative to repo (conf file)
4. `chmod +x *.sh; ./setup.sh`
5. Run `backup-sync` to manually sync, or wait for every 1 AM
