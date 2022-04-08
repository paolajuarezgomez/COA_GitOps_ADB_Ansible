
export LD_LIBRARY_PATH=/usr/lib/oracle/19.10/client64/lib

sudo unzip -o /tmp/adb_wallet.zip -d /usr/lib/oracle/19.10/client64/lib/network/admin/

sqlplus ADMIN/${password}@${ATP_alias} "@/tmp/config_backup.sql"
