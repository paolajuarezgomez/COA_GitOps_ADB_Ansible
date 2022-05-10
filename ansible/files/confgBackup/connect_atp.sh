#!/usr/bin/env bash
export LD_LIBRARY_PATH=/usr/lib/oracle/19.10/client64/lib

sqlplus ADMIN/password@alias "@/tmp/config_Backup.sql"
