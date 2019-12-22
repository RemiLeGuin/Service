# Service

**This repository is under construction.** It contains an unlocked package version of a typical Salesforce Service Cloud application.

## Initiate a scratch org for development

After creating a default scratch org with alias 'ServiceSO' in Visual Studio Code.

Add the following line to the Form Profile:

```
<userLicense>Guest User License</userLicense>
```

Execute the following command-lines:

```
sfdx force:package:install --package 04t1n0000021jWVAAY --wait 10 --publishwait 10 --targetusername ServiceSO
sfdx force:package:install --package 04t3X000001FDA6QAO --installationkey TriggerDependencyInjection --wait 10 --publishwait 10 --targetusername ServiceSO
sfdx force:package:install --package 04t3X000001HPzMQAW --wait 10 --publishwait 10 --targetusername ServiceSO
sfdx force:package:install --package 04t3X000001Hb1rQAC --installationkey Core2019 --wait 10 --publishwait 10 --targetusername ServiceSO
sfdx force:source:push --targetusername ServiceSO
sfdx force:user:permset:assign --permsetname Service_AutomatedProcesses --targetusername ServiceSO
```

Assign the Service_AutoResponseForm permission set to the Form Site Guest User.

Replace Record Type IDs in the Case datasets files and execute the following command-lines:

```
sfdx force:data:tree:import --plan datasets/MajorAccounts-plan.json --targetusername ServiceSO
sfdx force:data:tree:import --plan datasets/PublicDeals-plan.json --targetusername ServiceSO
sfdx force:data:tree:import --plan datasets/Restitutions-plan.json --targetusername ServiceSO
sfdx force:data:tree:import --plan datasets/Services-plan.json --targetusername ServiceSO
```

Ignore modifications in Case datasets files from Git

Create an Email-to-Case configuration