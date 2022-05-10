# COA Deploy Ansible with GitHub UseCase. 
# -- How to build ansible pipeline with GitHub Action  --

## ✅ Showcase

GitHub Actions is a continuous integration and continuous delivery (CI/CD) platform that allows you to automate your build, test, and deployment pipeline. You can create workflows that build and test every pull request to your repository, or deploy merged pull requests to production.

A workflow is a configurable automated process that will run one or more jobs. Workflows are defined by a YAML file checked in to your repository and will run when triggered by an event in your repository, or they can be triggered manually, or at a defined schedule.

During this UseCase we're going to:

* Use Github Actions to build different pipelines/workflows.
* Create a test workflow using Lint ansible.
* Run gitops operations in an ATP workload using ansible playbooks.

## ✅ Usage

* Clone this repo in GitHub and create you own repository.
* The first thing you’ll need to do before your GitHub Actions can run is to add your credentials to the repository. To do this you will need to follow these steps:

   * Navigate to your repository and select the Settings tab.
   * Once there you should see on the left a Secrets section third from the bottom of the list, click on that.
   * Click on the New repository secret button. 
   * Add the next secrets:

````
SSH_PRIVATE_KEY
VAULT_PASSWORD
````
* The *SSH_PRIVATE_KEY* is the ssh key necesary to connecto to the bastion
* The *VAULT_PASSWORD* is the password used for ansible-vault for encrypt the files that contain secrets

* The pipelines/workflows configuration are defined in the directory **.github/workflows**, in this case we have created two different workdlows: **LintAnsible.yaml and **DeployAnsible.yaml**
* Go to settings of your repo, and active the use of workflows.(*Settings-> Actions-> General-> Allow all actions and reusable workflows*)

* Create a new branch, review the different playbooks examples in /ansible/playbooks , copy the content os the choose operation in ./ansible/playbook.yaml and publish the changes to the new branch. 

* Open a "merge pull request" and check how the first  pipeline run:
![tabactions](images/Pullreques.png)

![tabactions](images/Pullreques1.png)

* When you approve the merge, the "ansible deploy" pipeline will be automatically launched.
![meergeends](images/meergeends.png)

* After the provisioning, the outcome of the apply step is showed in the merge request page.(*Pull requests -> closed -> pull request created* )
![console](images/OutcomeApply.png)

* If we review tab "actions" , we can check the two different pipelines:
![tabactions](images/tabactions.png)


## ✅ References
* [Understanding GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions)


