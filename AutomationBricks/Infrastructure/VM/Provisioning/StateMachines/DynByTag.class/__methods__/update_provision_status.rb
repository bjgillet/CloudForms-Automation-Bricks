#
# Description: This method updates the provision status.
# Required inputs: status
# 
#-----------------------------------------------------------------------------------------------------------
# Added : Loging current StateMachine for dynamic state machine select validation 
#

@debug = true

#-----------------------------------------------------------------------------------------------------------
#	:	loginfo(message) : Simple :info logging function
#

def loginfo(message)
  $evm.log(:info,message)
end

############################################################################################################
#		:
#		:		Main Code
#		:

prov = $evm.root['miq_provision']
unless prov
  $evm.log(:error, "miq_provision object not provided")
  exit(MIQ_STOP)
end

#	:	Loging used StateMachine
loginfo(" ===> Current VM provisioning StateMachine : #{$evm.current_namespace}/#{$evm.current_class}/#{$evm.current_instance}")

status = $evm.inputs['status']
# Update Status Message
updated_message  = "[#{$evm.root['miq_server'].name}] "
updated_message += "VM [#{prov.get_option(:vm_target_name)}] "
updated_message += "Step [#{$evm.root['ae_state']}] "
updated_message += "Status [#{status}] "
updated_message += "Message [#{prov.message}] "
updated_message += "Current Retry Number [#{$evm.root['ae_state_retries']}]" if $evm.root['ae_result'] == 'retry'
prov.miq_request.user_message = updated_message
prov.message = status

if $evm.root['ae_result'] == "error"
  $evm.create_notification(:level => "error", :subject => prov.miq_request, \
                           :message => "VM Provision Error: #{updated_message}")
  $evm.log(:error, "VM Provision Error: #{updated_message}")
end
