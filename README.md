# COA Deploy TRF with GitHub UseCase. 
# -- How to build a pipeline with GitHub Action  --

This example creates an Autonomous Database (JSON) exposed to the public Internet.

## ✅ Showcase

During this UseCase we're going to:

* Use Github Actions to build a pipeline.
* Use OCI S3 as a backed for terraform.
* Use OCI Vault for storing sensitive information.
* Deploy IaC using Terraform, in this case an ADB resource.

## ✅ Usage



* The first thing you’ll need to do before your GitHub Actions can run is to add your credentials to the repository. To do this you will need to follow these steps:

Navigate to your repository and select the Settings tab.
Once there you should see on the left a Secrets section third from the bottom of the list, click on that.
Click on the New repository secret button.
Add your AWS_SECRET_ACCESS_KEY and click the Add secret button.
Repeat step 3 and add your AWS_ACCESS_KEY_ID and click the Add secret button.


* Create an object storage [bucket](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformUsingObjectStore.htm) called *"terraform-backend"*.
* We want to use a [S3-Compatible Backend](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformUsingObjectStore.htm) , read the documentation carefully.
* Create a ["Customer Secret keys"](https://docs.oracle.com/en-us/iaas/Content/Identity/Tasks/managingcredentials.htm#To4) also named as "Amazon S3 Compatibility API keys". A Customer Secret key consists of an Access Key/Secret key pair. 
* Declare the below variables to OCI vault as secrets

````
tenancy_ocid
compartment_ocid
````

* Clone this repo in OraHub, GitLab or GitHub and create you own DevOps repository.
* Fill the correct OCID values of secrets in file **build_spec.yaml**
* Add your *api_private_key* to the file **user.pem**
* Rename the file **terraform.tfvars.template** to **terraform.tfvars** and add the values of your *tenancy_ocid* and *compartment_ocid*
* Define the values of your *region* and *adb_password* in the file **adb.auto.tfvars**
* Define the values of your *region* and *namespace* in the file **remote_backend.tf**
* Create a OCI DevOps Project
* Review [OCI documentation](https://docs.public.oneportal.content.oci.oraclecloud.com/en-us/iaas/Content/devops/using/devops_iampolicies.htm ) and add the required DG and policies. 

* Configure a code repository in DevOps to [mirror](https://docs.oracle.com/en-us/iaas/Content/devops/using/mirror_repo.htm ) the repository you have created in the previous step.
![DevOps Repository Mirroring](images/repository.png)

* Create a build pipeline and create a manage build.
![BuildPipeline](images/BuildPipeline.png)
![AddStage](images/AddStage.png)
![ManageBuild](images/ManagedBuild.png)
![AddStage](images/AddStage1.png)
![AddStage](images/PrimaryCode.png)

* Enable logging.
![Logging](images/Logging.png)

* Run the build pipeline manually and review the implementation.

![manually](images/manually.png)

![RunProgress](images/RunProgress.png)

![steps](images/steps.png)
![Logs](images/Logs.png)

* Check that now you can see the database provisioned in your compartment.
![steps](images/console.png)

* If you have arrived at this point with a successful outcome, you can add a [trigger](https://docs.oracle.com/en-us/iaas/Content/devops/using/trigger_build.htm#trigger_build) to lunch the pipeline automatically after any push action to your repository.

![trigger](images/trigger.png)
![createtrigger](images/createTrigger.png)
![Add](images/addaction.png)

* Remove manually (using OCI Console) the ADB created previously.
* Change you repo code, for example change the ADB name, and push the changes.
* Review the outcome:

![Outcome](images/Outcome.png)
![ConsoleOutcome](images/ConsoleOutcome.png)

If you need help, ask us in the slack channel #iac-enablement

## ✅ References
* [https://acloudguru.com/blog/engineering/how-to-use-github-actions-to-automate-terraform](https://acloudguru.com/blog/engineering/how-to-use-github-actions-to-automate-terraform)
