CloudForms / ManageIQ automation bricks

This repository contains automation components that, I believe, may be useful.

Each component is presented thereafter with a short description.
Following component link will bring you to the full component description including use cases, design logic and if necessary technical related hints. 

Click the brick title to go to it’s unit page.

Components may be downloaded from their unit page when possible or globally from a datastore export from that landing point.

Here is the list of the components :

[[TOC]]

* * *


# [Dynamic VM provisioning/retirement StateMachine selection](TaggedStateMachines/Readme.md)

VM StateMachines are defined by default. This brick dynamically select specific VM StateMachines depending on context. 

Use cases examples :

*  Within complex projects, several provisioning/retirement context with different workflows, constraints or  infrastructure tools may exist requiring different provisioning/retirement steps.

* A manually provisioned VM will not have to use a service ordered VM StateMachine as it hav not to (or can not) provide specific parameters or comply to this service placement constraints..

* As several parallel implementations, use cases, developments or tests are enabled, each context requires it’s own StateMachines that won’t interfere with others concurring enabled namespaces at the same time.

Quite any switching criteria may be chosen and implemented.

This implementation case is based on catalog item service template tagging, so to select appropriate StateMachine for both item’s provisioning and retirement. 

Within this git AutomationBricks namespace, it will be used quite anywhere as it let’s create dedicated running/testing/breaking(sometimes) contexts that do not interfere with others which respective domains are enabled at the same time.

* * *
