# CloudForms / ManageIQ AutomationBricks

AutomationBricks is a set of integration primitives for CLoudForms / ManageIQ.
They have been designed to be as easily reusable and implementable as possible.

## Importing AutomationBricks

### Importing the AutomationBricks Domain
Download the AutomationBricks.zip file.
On a CloudForms/ManageIQ appliance portal do as follow :
 * CloudForms 4.2 (cfme 5.7.\*) or previous : Go to Automate->Import/Export. 
 * CloudForms 4.5 (cfme 5.8.\*) or later : Go to Automation->Automate->Import/Export
Once there, any release click Choose file, select the downloaded zip, click upload.
Select all namespaces than import.

Once imported, your AutomationBricks domain could be disabled. Select your AutomationBricks domain, select Configuration->Edit, check th enabled box option, then save.

Starting with CloudForms 4.2, you may do a direct import from git but I currently do not recommend this option.
As imported, AutomationBricks would be locked that is probably not the option you would prefer for testing, updating or rollbacking it in time.

### Importing the AutomationBricks dialogs
At current release there are no dialogs within automation bricks. When it will be the case, we will update this short notice.

## Bricks documentation
As Bricks will be produced, they will be documented.
As a brand new project, documentation is currently under initial design.

An initial set of docs were created but have been currently removed as several design changes have occured in March 2018. In case you would have a set of those doc (initially published on this git, outside of it's wiki) do not use it. It is now inaccurate and sometimes wrong regarding current release.

The current documentations may be consulted on this git wiki page, accessible from the main menu or through the following link :

[AutomationBricks Documentation Home](https://github.com/bjgillet/CloudForms-Automation-Bricks/wiki/Home)

This notice will be updated as documentation options will be definitives (finalizing designs and processes).

