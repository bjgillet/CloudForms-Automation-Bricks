## CloudForms / ManageIQ automation bricks

This repository contains automation components that, I believe, may be useful.
Each of them is presented thereafter with a short description.
Component title link will bring you to the full component description. 
Components may be downloaded from their unit page when possible or globally from this page landing point.

Here is the list of the current components :

* <<dynprov,Dynamic VM provisioning/retirement StateMachine selection>>
* <<task_race,Task level race conditions management>>

[dynprov]
### [Dynamic VM provisioning/retirement StateMachine selection](docs/DynVm.asciidoc)

### link:docs/DynTagStateMachine/doc.asciidoc[Test acces doc relative]


VM StateMachines are defined by default. This brick dynamically select specific VM StateMachines depending on context. 

Use cases examples : 

 *  Within complex environments, several provisioning/retirement context with  different workflows, constraints or  infrastructure implementations may exist  requiring different provisioning/retirement steps.
 *  A manually provisioned VM will not have to use a specific VM StateMachine  as it have not to (or can not) provide specific parameters or comply to this service placement constraints.
 *  As several parallel implementations, use cases, developments or tests are enabled, each context requires it’s own StateMachines that won’t interfere with others concurring enabled namespaces at the same time.
  
This implementation case is based on catalog item service template tagging, so to select appropriate StateMachine for both item’s provisioning and retirement.

''''
