############################################################################################################
# 
# Method : get_state_machine
# 
# Description: 
#	Sets $evm.root State Machine to a vm_[prov,ret]_custom tag based name if existing in service_template
#   If a custom state machine is required, it will replace $evm.root value
#   If not, this method will set default miq VM StateMachine as did original MiQ instance.
#   vm_[prov,ret]_custom tag contains a state machine name to be modified to match camel case.
#   i.e. : if tag="custom_state_machine", state machine class will be "CustomStateMachine"
#	Name of the instance is un-changed in that use-case.
#
# Requires from instance :
#   provision_category and retire_category = Tag categories defining custom StateMachine name tag
#   prov_msg = calling message for provisioning
#   ret_msg = calling message for retirement
#
# Author : Bruno Gillet - bgillet@redhat.com
#
# Tested with : CF 4.2, CF 4.5
#

@debug = true

#-----------------------------------------------------------------------------------------------------------
#	:	loginfo(message) : Simple :info logging function
#

def loginfo(message)
  $evm.log(:info,message)
end

#-----------------------------------------------------------------------------------------------------------
#	:	get_instance_tagcat : Getting context tag category from instance
#	:	pre-requisites : 
#	:		@message - initialized from main code
#	:	Returns :
#	:		tag category for current message or nil if none found from instance
#

def get_instance_tagcat
  tag_cat = nil
  case @message
    when $evm.current['prov_msg']
      tag_cat = $evm.current['provision_category']
    when $evm.current['ret_msg']
      tag_cat = $evm.current['retire_category']
  end
  loginfo("--> Called with message : #{@message} - tag category : #{tag_cat}") if @debug
  
  tag_cat
end

#-----------------------------------------------------------------------------------------------------------
#	:	get_svc_tmpl_tag(tag_cat) - Getting custom StateMachine class name
#	:	Parameters :
#	:		tag_cat = tag category to search for
#	:	Returns :
#	:		valid state_machine name or nil so to get back to default later on.
#

def get_svc_tmpl_tag(tag_cat)
  state_machine = nil
  prov = $evm.root['miq_provision'] || $evm.root['vm'].miq_provision
  svc_tmpl_name = prov.options[:name]
  svc_tmpl = $evm.vmdb(:service_template).find_by_name(svc_tmpl_name)
  loginfo("--> got service_template : #{svc_tmpl.name} - ID: #{svc_tmpl.id}") if @debug

  svc_tmpl.tags.each do |tag|
    tab=tag.split("/")
    if tab.first == tag_cat
       state_machine = tab.last
    end
  end
  state_machine
end

#-----------------------------------------------------------------------------------------------------------
#	:	init_state_machine(state_machine) : Getting custom StateMachine class name
#	:	Parameters : 
#	:	  state_machine	=	StateMachine name if tmpl tagged
#	:						nil if not (back to default StateMachine)
#	:

def init_state_machine(state_machine)
  case @message
    when $evm.current['prov_msg']
      $evm.root['state_machine'] = state_machine.nil? ? $evm.current['def_prov_statemachine'] : state_machine
      loginfo("--> Setting prov. state_machine class to: #{$evm.root['state_machine']}")
    when $evm.current['ret_msg']
      target_class = state_machine.nil? ? $evm.current['def_ret_class'] : state_machine
      loginfo("--> Setting ret. state_machine class to: #{target_class}")
      $evm.instantiate("#{$evm.current['def_ret_namespace']}/#{target_class}/#{$evm.current['def_ret_instance']}")
    else
      loginfo("===> No known message transmitted = nothing done ! Please, send a known message from instance definition")
  end
end

############################################################################################################
#		:
#		:		Main Code
#		:

loginfo("---> get_statemachine starting")

@message = $evm.current_message

tag_cat = get_instance_tagcat
unless tag_cat.nil?
  state_machine = get_svc_tmpl_tag(tag_cat) 
  unless state_machine.nil?
    #	:	building CamelCase class name from snake case tag
    state_machine = state_machine.gsub('_',' ').titleize.tr(' ','')
  else
    #	:	Template untagged. Mapping to default.
    loginfo("--> No custom state_machine found for service template / mapping to default StateMachine")
  end
else
  #		:	Issue with instance/tags definition. No exception however.
  loginfo("--> No tag category in instance for message : #{$evm.current_message}")
end

#	:	Will transmit either valid state_machine name or nil to map back to default.
init_state_machine(state_machine)
