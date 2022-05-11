
## ✅ How to use ansible-vault to encryt files in ansible pipelines

The ansible-vault command is the main interface for managing encrypted content within Ansible. For example in this repo we had the file *conf* encrypted. To create this file we have folloews the next steps:

In a machine with ansible installed,  run:

````
ansible-vault create config
````

*Output*
````
New Vault password: 
Confirm New Vault password:
````

include the secret information
````
[DEFAULT]
user=ocid1.user.oc1..******
fingerprint=******
key_file=/root/.oci/oci_api_key.pem
tenancy=ocid1.tenancy.******
region=uk-london-1
````

cat config 
````
[DEFAULT]
user=ocid1.user.oc1..******
fingerprint=******
key_file=/root/.oci/oci_api_key.pem
tenancy=ocid1.tenancy.******
region=uk-london-1
````

If you want to review the content of a encrypted file you can use the command 
````
ansible-vault view <file-name> 
````
