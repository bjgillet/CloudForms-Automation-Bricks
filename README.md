<h1><a name="h.npkt22k05p2b"></a>CloudForms / ManageIQ automation
bricks</h1>
<p>This repository contains automation components that, I believe,
may be useful.</p>
<p>Each component is presented thereafter with a short
description.<br/>
Following component link will bring you to the full
component description including use cases, design logic and if
necessary technical related hints.
</p>
<p>Click the brick title to go to it’s unit page.</p>
<p>Components may be downloaded from their unit page when possible or
globally from  datastore export from that landing point.</p>
<p>Here is the list of the components :</p>
<p><a href="#truc">Dynamic VM provisioning/retirement
StateMachine selection</a></p>
<hr/>

<h2><a name="truc"></a><a href="http://taggedstatemachines/Readme.md">
VM provisioning/retirement StateMachine selection</a></h2>
<p>VM StateMachines are defined by default. This brick dynamically
select specific VM StateMachines depending on context.
</p>
<p>Use cases examples :</p>
<ul>
        <li/>
<p >Within complex projects,
        several provisioning/retirement context with different workflows,
        constraints or &nbsp;infrastructure tools may exist requiring
        different provisioning/retirement steps.</p>
        <li/>
<p style="margin-bottom: 0cm">A manually provisioned VM will
        not have to use a service ordered VM StateMachine as it hav not to
        (or can not) provide specific parameters or comply to this service
        placement constraints..</p>
        <li/>
<p>As several parallel implementations, use cases,
        developments or tests are enabled, each context requires it’s own
        StateMachines that won’t interfere with others concurring enabled
        namespaces at the same time.</p>
</ul>
<p>Quite any switching criteria may be chosen and implemented.</p>
<p>This implementation case is based on catalog item service template
tagging, so to select appropriate StateMachine for both item’s
provisioning and retirement.
</p>
<p>Within this git AutomationBricks namespace, it will be used quite
anywhere as it let’s create dedicated
running/testing/breaking(sometimes) contexts that do not interfere
with others which respective domains are enabled at the same time.</p>

