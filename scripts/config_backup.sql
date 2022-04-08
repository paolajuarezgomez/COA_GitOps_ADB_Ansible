

SET HEAD OFF
SET AUTOPRINT OFF
SET TERMOUT OFF
SET SERVEROUTPUT ON
SPOOL salida.log
WHENEVER SQLERROR EXIT SQL.SQLCODE
ALTER DATABASE PROPERTY SET default_backup_bucket='https://swiftobjectstorage.${region}.oraclecloud.com/v1/${namespace}/${bucket}';
SET DEFINE OFF
BEGIN
  DBMS_CLOUD.CREATE_CREDENTIAL(
    credential_name => 'ATP',
    username => '${username}',
    password => '${password}'
);
END;
/
ALTER DATABASE PROPERTY SET default_credential = 'ADMIN.ATP';
BEGIN
   DBMS_CLOUD.DROP_CREDENTIAL('ADMIN.ATP');
END;
/
select owner, credential_name, username, enabled from dba_credentials;
select object_name, bytes from dbms_cloud.list_objects('ATP','https://swiftobjectstorage.${region}.oraclecloud.com/v1/${namespace}/${bucket}');
exit;
