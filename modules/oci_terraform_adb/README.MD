# Oracle Cloud Infrastructure (OCI) Autonomous Database (ADB) Module for Terraform

# 1. Introduction

This module provides a generic way to provision any kind of Oracle Autonomous Database (ATP, ADW, AJD or APEX) and in any kind of available infrastructure (Shared, Dedicated) in Oracle Cloud Infrastructure (OCI).

# 2. Solution

Autonomous Databases are the best PaaS database service for using Oracle Database in OCI. It provides an easy way to start developing your application without the need to worry about many maintenance operations, administration or performance management.

## 2.1. Prerequisites

Most of prerequisites would depend on type of infrastructure, network access type, source for DB creation and type of workload. Thus, well have:

### 2.1.1 Dedicated infrastructure

For dedicated deployments you will need, beforehand to ADB provisioning you need:

* Autonomous Exadata Infrastructure created
* Autonomous Exadata VM Cluster created over the Autonomous Exadata Infrastructure
* Autonomous Container Database over the Autonomous Exadata VM Cluster

### 2.1.2 Shared infrastructure

In shared infrastructure deployments the most important prerequisites will be those related with the network access type. We have: 

1) Access from everywhere: No prerequites at all
2) Secure access from allowed IPs and VCNs only (ACLs). When defining ACL's you can configure a combination of:
   * Allowed source IP address (list of) which can connect to the ADB
   * CIDR block of allowed source of clients allowed to connect to the ADB
   * A VCN with IP's or CIDR blocks allowed to connecto to the ADB
   * A VCN OCID with IP's or CIDR blocks allowed to connecto to the ADB
3) Private endpoint access. For this kind of access you will need:
   *  A VCN where to put the endpoint of your ADB
   *  A Subnet where to assigned (by DHCP) a private IP for your ADB
   *  A Network Security Group (NSG), where to put the security rules to govern the access from the DB clients to the ADB

### 2.1.3 Common prerrequisites

If you need to apply your own encryption keys using Oracle Key Vault service for your database transparent data encryption (TDE), you will need:
 1) Your OKV vault ID (OCID)
 2) The OCID of the key container used as the master encryption key

After the deployment of your ADB, you could need to have a bastion (or jumphost) available for being able to access your fresh deployed ADB, depending on network access method selected (Private Endpoint for sure, based on ACL's will depend of source IP).

## 2.2. Getting Started

Some examples has been provided under the `examples` folder. Every example's README.md file will give you detailed instructions about the specific example.

The module doesn't have any default values at this time, so you will have to declare the `adb` variable for the values you're going to use (see Inputs below).

## 2.3. Inputs

The `adb` input variable represent an object with all the valid arguments that the autonomous Terraform module uses. 

The valid arguments are the following:

| Attribute | Data Type | Required | Updatable | Valid Values | Description | Example |
| --- | --- | --- | --- | --- | --- | --- | 
| compartment_id | string | yes | no | compartment's OCID | Compartment that will be used to locate this new ADB. The compartment must exist. | N/A | 
| db_name | string | yes | no | Must begin with an alphabetic character and can contain a maximum of 14 alphanumeric characters. Special characters are not permitted. | Database name must be unique in the tenancy | DBATP1 |
| display_name | string | no | yes | any | User-friendly name for the ADB. Name does not have to be unique | DBATP1 | 
| admin_password | string | no | yes | Must be between 12 and 30 characters long, must contain at least 1 uppercase, 1 lowercase, and 1 numeric character. Cannot contain the double quote symbol ("), username "admin" regardless of casing. | Mandatory if source value is "BACKUP_FROM_ID", "BACKUP_FROM_TIMESTAMP", "DATABASE" or "NONE". NOTICE: Better to maintain this attribute in your terraform.tfvars and ignore to push to GIT for security reasons. | Welcome12345 |
| are_primary_whitelisted_ips_used | bool | no | yes | true / false | Will be null if the ADB is not Data Guard enabled or Access Control is disabled. Will be `true` if ADB is Data Guard enabled and Access Control is enabled and if the ADB uses primary IP ACL for standby. Will be `false` if ADB is Data Guard enabled and Access Control is enabled and if the ADB uses different IP ACL for standby compared to primary | N/A |
| cpu_core_count | string | no | yes | Positive numbers | Number of OCPU cores to be made available to the database. For ADB on ***dedicated*** Exadata infrastructure. Maximum number of cores is determined by infrastructure. Can not be used with ***ocpuCount*** parameter. Ignored for Always Free resources | 2 |
| ocpu_count | string | no | yes | Positive numbers and fractions (only on dedicated infrastructure) | Number of OCPU cores to be made available to the database. Rules: For ADB over dedicated Exadata infrastructure, to provision less than 1 core, enter a fractional value in an increment of 0.1. For example, you can provision 0.3 or 0.4 cores, but not 0.35 cores (fractions not supported on shared Exadata infrastructure); To provision 1 or more cores, you must enter an integer between 1 and the maximum number of cores available for the infrastructure shape. For example, you can provision 2 cores or 3 cores, but not 2.5 cores (valid for dedicated and shared Exadata infrastructures). | 1 | 
| customer_contacts | list(object) | no | yes | List of pairs {email:value} | Email contacts for availability or announcements of the ADB to be created | [{"email":"jane.doe@foo.com"},{"email":"john.doe@foo.com"}] |
| data_storage_size_in_gb | string | no | yes | Positive number greater than 1 | Size in gigabytes of the data volume that will be created and attached to the database. This storage can later be scaled up or down if needed. The maximum storage value is determined by the infrastructure shape. Only supported for ***dedicated*** Exadata infrastructure. Incompatible with data_storage_size_in_tbs. | 2 | 
| data_storage_size_in_tbs | string | no | yes | Positive number greater than 1 | Size in terabytes of the data volume that will be created and attached to the database. This storage can later be scaled up or down if needed. For ADB on dedicated Exadata infrastructure, the maximum storage value is determined by the infrastructure shape. Incompatible with data_storage_size_in_gbs. | 2 | 
| data_safe_status | string | no | yes | REGISTERED / NOT_REGISTERED | Status of the Data Safe registration | NOT_REGISTERED |
| db_version | string | no | yes | 19c / 21c | Valid Oracle Database version for ADB. AJD and APEX only support 19c. Jusst the Always Free supports currently 21c version | 19c |
| db_workload | string | no | yes | OLTP / DW / AJD / APEX | The ADB workload type, which could be: OLTP indicates Autonomous Transaction Processing; DW indicates Autonomous Data Warehouse database; AJD indicates Autonomous JSON database; APEX indicates and ADB with Oracle APEX Application Development workload type. NOTICE: Can just be updated from AJD -> OLTP or from free OLTP to AJD. | OLTP |
| defined_tags | map(string) | no | yes | Pairs of {key:value} | Defined tags for this resource. Each key is predefined and scoped to a namespace. | N/A |
| freeform_tags | map(string) | no | yes | Pairs of {key:value} | Free-form tags for this resource. Each tag is a simple key-value pair with no predefined name, type or namespace. | {"Department": "Finance"} | 
| is_access_control_enabled | bool | no | yes | true / false | Only applicable to ADB on Exadata Cloud@Customer. Indicates if the database-level access control is enabled. If disabled, database access is defined by the network security rules. If enabled, database access is restricted to the IP addresses defined by the rules specified with the whitelisted_ips property. While specifying whitelisted_ips rules is optional, if database-level access control is enabled and no rules are specified, the database will become inaccessible. The rules can be added later updating the whielisted_ips. When creating a database clone, the desired access control setting should be specified. By default, database-level access control will be disabled for the clone. | N/A |
| is_auto_scaling_enabled | bool | no | yes | true / false | Indicates if auto scaling is enabled for the ADB OCPU core count. Default is `false` | N/A |
| is_data_guard_enabled | bool | no | yes | true / false | Indicates whether the ADB has local (in-region) Data Guard enabled. Not applicable to cross-region Autonomous Data Guard associations, or to Autonomous Databases using dedicated Exadata infrastructure or Exadata Cloud@Customer infrastructure | N/A | 
| is_free_tier | bool | no | yes | true/false | Indicates if this is an Always Free resource. Default is `false`. If workload type is AJD or APEX it can not be true | N/A | 
| is_mtls_connection_required | bool | no | yes | true / false | Indicates whether the ADB requires mTLS connections. | N/A | 
| is_refreshable_clone | bool | no | yes | true / false | Applies when source=CLONE_TO_REFRESHABLE only. True for creating a refreshable clone and False for detaching the clone from source ADB. Detaching is one time operation and clone becomes a regular ADB. | N/A | 
| license_model | string | no (yes if AJD) | yes | BRING_YOUR_OWN_LICENSE / LICENSE_INCLUDED | Oracle license model that applies to the ADB. Bring your own license (BYOL) allows you to apply your current on-premises Oracle software licenses. License Included allows you to subscribe to new Oracle Database software licenses and the Database service. Note that when provisioning an Autonomous Database on dedicated Exadata infrastructure, this attribute must be null because the attribute is already set at the Autonomous Exadata Infrastructure level. When using shared Exadata infrastructure, if a value is not specified, the system will supply the value of BRING_YOUR_OWN_LICENSE. It is a required field when db_workload is AJD and needs to be set to LICENSE_INCLUDED as AJD does not support default license_model value BRING_YOUR_OWN_LICENSE. | BRING_YOUR_OWN_LICENSE | 
| nsg_ids | list(string) | no (if network access = private endpoint, then yes) | yes | ["string","string"...] | List of the OCIDs of the network security groups (NSGs) that this resource belongs to. Setting this to an empty array after the list is created removes the resource from all NSGs. | ["NSG_OCID1","NSG_OCID2"...] | 
| refreshable_mode | string | no | yes | AUTOMATIC | Applies when source=CLONE_TO_REFRESHABLE. The refresh mode of the clone. AUTOMATIC indicates that the clone is automatically being refreshed with data from the source ADB. | AUTOMATIC | 
| operations_insights_status | string | no | yes | ENABLED / NOT_ENABLED | Status of Operations Insights for this ADB | NOT_ENABLED |
| private_endpoint_label | string | no | yes | string | The private endpoint label for the resource in the DNS domain for the VCN where it is created. | DBATP1 | 
| rotate_key_trigger | string | no | yes | | Applies on dedicated infrastructure. An optional property when flipped triggers rotation of KMS key. | | 
| scheduled_operations | list(object) | no | yes | [{"day_of_week":[{"name":"string"}],"scheduled_start_time":"string with time in ISO-8601 format HH:mm","scheduled_stop_time":"string with time in ISO-8601 format HH:mm"},...] | List of scheduled operations. `day_of_week` states for the day of the week you want to program auto start/stop. `scheduled_start_time` is the auto start time. `scheduled_stop_time` is the auto stop time. | [{"day_of_week":[{"name":"MONDAY"}],"scheduled_start_time":"09:00","scheduled_stop_time":"20:00"},{"day_of_week":[{"name":"TUESDAY"}],"scheduled_start_time":"09:00","scheduled_stop_time":"20:00"},{"day_of_week":[{"name":"WEDNESDAY"}],"scheduled_start_time":"09:00","scheduled_stop_time":"20:00"},{"day_of_week":[{"name":"THURSDAY"}],"scheduled_start_time":"09:00","scheduled_stop_time":"20:00"},{"day_of_week":[{"name":"FRIDAY"}],"scheduled_start_time":"09:00","scheduled_stop_time":"18:00"}] |
| standby_whitelisted_ips | list(string) | no | yes | ["string", "string",...] | The client IP access control list (ACL). This feature is available for ADB on shared Exadata infrastructure and on Exadata Cloud@Customer. Only clients connecting from an IP address included in the ACL may access the ADB instance. For shared Exadata infrastructure, this is an array of CIDR (Classless Inter-Domain Routing) notations for a subnet or VCN OCID. Use a semicolon (;) as a deliminator between the VCN-specific subnets or IPs. For Exadata Cloud@Customer, this is an array of IP addresses or CIDR (Classless Inter-Domain Routing) notations. If you want to delete all the IPs in the ACL, use an array with a single empty string entry. | ["1.1.1.1","1.1.1.0/24","ocid1.vcn.oc1.sea.<unique_id>","ocid1.vcn.oc1.sea.<unique_id1>;1.1.1.1","ocid1.vcn.oc1.sea.<unique_id2>;1.1.0.0/16"] | 
| state | string | no | yes | AVAILABLE / STOPPED | Running state of the ADB. You can stop or start the ADB by altering between values. | AVAILABLE | 
| subnet_id | string | no | yes | OCID | OCID of the subnet the resource is associated with. Setting this will disable public secure access to the database. | N/A | 
| whitelisted_ips | list(string) | no | yes | ["strint","string"...] | The client IP access control list (ACL). This feature is available for ADB on shared Exadata infrastructure and on Exadata Cloud@Customer. Only clients connecting from an IP address included in the ACL may access the ADB instance. For shared Exadata infrastructure, this is an array of CIDR (Classless Inter-Domain Routing) notations for a subnet or VCN OCID. Use a semicolon (;) as a deliminator between the VCN-specific subnets or IPs. For Exadata Cloud@Customer, this is an array of IP addresses or CIDR (Classless Inter-Domain Routing) notations. If you want to delete all the IPs in the ACL, use an array with a single empty string entry. | ["1.1.1.1","1.1.1.0/24","ocid1.vcn.oc1.sea.<unique_id>","ocid1.vcn.oc1.sea.<unique_id1>;1.1.1.1","ocid1.vcn.oc1.sea.<unique_id2>;1.1.0.0/16"] |
| autonomous_container_database_id | string | no | no | OCID | Applies to dedicated infrastructure. The Autonomous Container Database OCID | N/A |
| autonomous_database_backup_id | string | no (required if source=BACKUP_FROM_ID) | no | OCID | The OCID of the source ADB Backup that you will clone to create a new ADB | N/A | 
| autonomous_database_id | string | no (required if source=SOURCE_FROM_TIMESTAMP) | no | OCID | The OCID of the source ADB that you will clone to create a new ADB. | N/A | 
| clone_type | string | no (required if source=BACKUP_FROM_ID / BACKUP_FROM_TIMESTAMP / DATABASE) | no | FULL / METADATA | The ADB clone type | FULL |
| autonomous_maintenance_schedule_type | string | no | no | EARLY / REGULAR | The maintenance schedule type of the ADB on shared Exadata infrastructure. The EARLY maintenance schedule of this ADB follows a schedule that applies patches prior to the REGULAR schedule.The REGULAR maintenance schedule of this ADB follows the normal cycle. | REGULAR |
| is_dedicated | bool | no | no | true / false | True if the database is on dedicated Exadata infrastructure. | N/A |
| is_preview_version_with_service_terms_accepted | bool | no | no | true / false | If set to TRUE, indicates that an ADB preview version is being provisioned, and that the preview version's terms of service have been accepted. Note that preview version software is only available for databases on shared Exadata infrastructure. | N/A | 
| kms_key_id | string | no | no | OCID | The OCID of the key container that is used as the master encryption key in database transparent data encryption (TDE) operations. | N/A | 
| source | string | no | no | NONE / DATABASE / CROSS_REGION_DATAGUARD / BACKUP_FROM_ID / BACKUP_FROM_TIMESTAMP | The source of the database: Use NONE for creating a new ADB. Use DATABASE for creating a new ADB by cloning an existing ADB. Use CROSS_REGION_DATAGUARD to create a standby Data Guard database in another region. For ADB on shared Exadata infrastructure, the following cloning options are available: Use BACKUP_FROM_ID for creating a new ADB from a specified backup. Use BACKUP_FROM_TIMESTAMP for creating a point-in-time ADB clone using backups. | NONE |
| source_id | string | no (required if source=CLONE_TO_REFRESHABLE / DATABASE) | no | OCID | The OCID of the source ADB that you will clone to create a new ADB. | N/A | 
| switchover_to | string | no | no | PRIMARY / STANDBY | Applies when `is_data_guard_enabled` is `true`. Could be set to PRIMARY or STANDBY. Default is PRIMARY | PRIMARY | 
| timestamp | string | no (required if source=BACKUP_FROM_TIMESTAMP) | no | | The timestamp specified for the point-in-time clone of the source Autonomous Database. The timestamp must be in the past. | |
| vault_id | string | no | no | OCID | The OCID of the Oracle Cloud Infrastructure vault. | N/A | 

***Example***
The following example creates an ATP-S database:

```
module "DBATP1" {
    source = "../../"
    default_compartment_id = var.default_compartment_id
    
    adb = {
        compartment_id                       = var.default_compartment_id
        db_name                              = "DBATP1"
        display_name                         = "DBATP1"
        admin_password                       = var.default_adb_admin_password
        are_primary_whitelisted_ips_used     = null
        ocpu_count                           = null
        cpu_core_count                       = "1"
        customer_contacts                    = []
        data_storage_size_in_gb              = null
        data_storage_size_in_tbs             = "1"
        data_safe_status                     = "NOT_REGISTERED"
        db_version                           = "19c"
        db_workload                          = "OLTP"
        defined_tags                         = {}
        freeform_tags                        = {}
        is_access_control_enabled            = null
        is_auto_scaling_enabled              = true
        is_data_guard_enabled                = false
        is_free_tier                         = false
        is_mtls_connection_required          = true
        is_refreshable_clone                 = null
        license_model                        = "BRING_YOUR_OWN_LICENSE"
        nsg_ids                              = ["<NSG OCID"]
        refreshable_mode                     = null
        operations_insights_status           = "NOT_ENABLED"
        private_endpoint_label               = "DBATP1"
        rotate_key_trigger                   = null
        scheduled_operations                 = [{"day_of_week":[{"name":"MONDAY"}],"scheduled_start_time":"09:00","scheduled_stop_time":"20:00"},{"day_of_week":[{"name":"TUESDAY"}],"scheduled_start_time":"09:00","scheduled_stop_time":"20:00"},{"day_of_week":[{"name":"WEDNESDAY"}],"scheduled_start_time":"09:00","scheduled_stop_time":"20:00"},{"day_of_week":[{"name":"THURSDAY"}],"scheduled_start_time":"09:00","scheduled_stop_time":"20:00"},{"day_of_week":[{"name":"FRIDAY"}],"scheduled_start_time":"09:00","scheduled_stop_time":"18:00"}]
        standby_whitelisted_ips              = []
        state                                = "AVAILABLE"
        subnet_id                            = "<Subnet OCID>"
        whitelisted_ips                      = []

        autonomous_container_database_id     = null
        autonomous_database_backup_id        = null
        autonomous_database_id               = null
        clone_type                           = null 
        autonomous_maintenance_schedule_type = "REGULAR"
        is_dedicated                         = false
        is_preview_version_with_service_terms_accepted = null
        kms_key_id                           = null
        source                               = null
        source_id                            = null
        switchover_to                        = null
        timestamp                            = null
        vault_id                             = null
    }
}
```

## 2.4. Outputs

Currently just the adb_id (OCID) of the new ADB created is returned.

## 2.5. Available operations

In this section we'll describe some possible operations which can be done by using Terraform and following a GitOps approach.

### 2.5.1. Scale compute 

It is possible to scale up or down OCPUs assigned to your ADB instance by using the `cpu_core_count` attribute (or `ocpu_count`). Just modify its value and perform a new apply to increase or decrease the CPU in a hot operation.

### 2.5.2. Scale storage

It is possible to scale up or down the storage capacity assigned to your ADB instance by using the `data_storage_size_in_tbs` attribute (or `data_storage_size_in_gb` in dedicated infrastructure). Just modify its value and perform a new apply to increase or decrease the storage capacity in a hot operation. It you try to down scale the storage capacity under the contents used capacity the operation will fail.

### 2.5.3. Manage auto-scaling

To enable/disable the auto-scaling feature you just have to change the value of the `is_auto_scaling_enabled` from false to true or vice versa and perform a new terraform apply.

### 2.5.4. Change running state (stop/start)

To stop or start your ADB, you can modify the argument `state` from ***AVAILABLE*** (started) to ***STOPEED*** to stop it. Changing from ***STOPPED*** to ***AVAILABLE*** will start your ADB. Just modify the argument and perform a new terraform apply.

### 2.5.5. Update ADB miscelaneaous information

Basically you should be able to modify any argument shown as updatable, despite some of them can have broader consecuences (as moving the ADB to other compartment, as you'll have to take into account security aspects as IAM policies). Some of them are:

* Change compartment -> updating `compartment_id`
* Update lycense type -> updating `license_model`. E.g.: Change from ***BRING_YOUR_OWN_LICENSE*** to ***LICENSE_INCLUDED*** (NOTICE: Your changes per OCPU used will change)
* Manage customer contacts -> updating `customer_contacts`. E.g.: Adding to the list new pairs of {email:value}
* Add new NSGs if you're using Private Endpoint network access -> updating `nsg_ids`
* Change the requirment for mTLS or not -> updating `is_mtls_connection_required`
* Rename the database (display name) -> updating `display_name`
* Add/modify tags -> updating `defined_tags` (requires you to know the namespace) or `freeform_tags`

# 3. Known problems

Nothing here so far.

# 4. Release Notes

See [release notes](./docs/release_notes.md) for release notes information.

# 5. URLs

N/A.

# 6. Contributing

This project is open source. Oracle appreciates any contributions that are made by the open source community.

# 7. License
Copyright (c) 2022 Oracle and/or its affiliates.

Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

See [LICENSE](LICENSE) for more details.
