############################################################################################################
# 
# Method : launch_state_machine
# 
# Description: 
#	Selects and launch State Machine from a set of  vm_[prov,ret]_[class,instance] tag names set on source catalog item.
#   If catalog item is tagged with such tags, StateMachine class and instance neams are derived from tags.
#   If not, this method will use default miq VM StateMachine as did original MiQ instance.
#
#   vm_[prov,ret]_class tag contains a snake_case state machine class name to be modified to match camel case.
#   i.e. : if class tag="custom_state_machine", state machine class will be "CustomStateMachine", same apply
#   to instances
#
# Author : Bruno Gillet - bgillet@redhat.com
#	- V1.0 - 2017/11 : maps State Machine to custom class only
#   - V1.1 - 2018/02 : maps StateMachine to both custom class and instance.
#	- V1.2 - 2018/03 : covers both Cloud and Infrastructure VMs StateMachines.
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
#	:	class_tagcat : returns class tag category name
#	:	pre-requisites : 
#	:		@message - initialized from main code

def class_tagcat
  tag_cat = nil
  case @message
    when $evm.current['prov_msg']
      tag_cat = $evm.current['provision_category']
    when $evm.current['ret_msg']
      tag_cat = $evm.current['retire_category']
  end
  loginfo("--> Called with message : #{@message} - class tag category : #{tag_cat}") if @debug
  
  tag_cat
end

#-----------------------------------------------------------------------------------------------------------
#	:	instance_tagcat : returns class tag category name
#	:	pre-requisites : 
#	:		@message - initialized from main code

def instance_tagcat
  tag_cat = nil
  case @message
    when $evm.current['prov_msg']
      tag_cat = $evm.current['prov_instance_cat']
    when $evm.current['ret_msg']
      tag_cat = $evm.current['ret_instance_cat']
  end
  loginfo("--> Called with message : #{@message} - instance tag category : #{tag_cat}") if @debug
  tag_cat
end

#-----------------------------------------------------------------------------------------------------------
#	:	get_svc_tmpl_tag(tag_cat) - Getting custom StateMachine class name
#	:	Requires :
#	:		@prov = miq_provision pre-initialized from main code.
#	:	Parameters :
#	:		tag_cat = tag category to search for
#	:	Returns :
#	:		valid state_machine name or nil so to get back to default later on.
#

def get_svc_tmpl_tag(tag_cat)
  target_name = nil
  svc_tmpl_name = @prov.options[:name]
  svc_tmpl = $evm.vmdb(:service_template).find_by_name(svc_tmpl_name)
  loginfo("--> got service_template : #{svc_tmpl.name} - ID: #{svc_tmpl.id}") if @debug

  svc_tmpl.tags.each do |tag|
    tab=tag.split("/")
    if tab.first == tag_cat
       target_name = tab.last
    end
  end
  target_name
end

#-----------------------------------------------------------------------------------------------------------
#	:	get_name(tag_cat) : Getting instance or class name
#	:	Requires :
#	:		@prov = miq_provision pre-initialized from main code.
#	:	Parameters : 
#	:	  tag_cat	=	Target category for class or instance name
#	:

def get_name(tag_cat)
  target_name=nil
  unless tag_cat.nil?
    target_name = get_svc_tmpl_tag(tag_cat) 
    unless target_name.nil?
      #	:	building CamelCase class name from snake case tag
      target_name = target_name.gsub('_',' ').titleize.tr(' ','')
    else
      #	:	Template untagged. Mapping to default.
      loginfo("--> No #{tag_cat} found for service template / mapping to default StateMachine")
    end
  else
    #		:	Issue with calling instance tag category definition. No exception however.
    loginfo("--> WARNING : No tag category for message : #{$evm.current_message}")
  end
  target_name
end

#-----------------------------------------------------------------------------------------------------------
#	:	run_state_machine(class_name, instance_name) : launches StateMachine
#	:	Requires :
#	:		@prov = miq_provision pre-initialized from main code.
#	:	Parameters : 
#	:	  class_name	=	StateMachine class name if item tagged
#	:						nil if not (back to default StateMachine)
#	:	  instance_name	=	StateMachine instance name if item tagged
#	:						nil if not (back to default StateMachine)
#	:

def run_state_machine(class_name, instance_name)
  target_state_machine = nil
  case @message
    when $evm.current['prov_msg']  
      $evm.root['state_machine'] = class_name.nil? ? $evm.current['def_prov_statemachine'] : class_name
      loginfo("--> Setting prov. state_machine class to: #{$evm.root['state_machine']}")
      target_instance = instance_name.nil? ? @prov.provision_type : instance_name
      target_state_machine = "#{$evm.current['def_prov_namespace']}/#{$evm.root['state_machine']}/#{target_instance}"
      loginfo("--> Target VM prov. StateMachine = #{target_state_machine}")
    
    when $evm.current['ret_msg']	
      target_class = class_name.nil? ? $evm.current['def_ret_class'] : class_name
      loginfo("--> Setting ret. state_machine class to: #{target_class}")
      $evm.set_state_var(:retire_state_machine,target_class)
      
      target_instance = instance_name.nil? ? $evm.current['def_ret_instance'] : instance_name
      retire_class = target_class.nil? ? $evm.current['def_ret_class'] : target_class
      target_state_machine = "#{$evm.current['def_ret_namespace']}/#{retire_class}/#{target_instance}"
      loginfo("--> Target VM ret. StateMachine with instance = #{target_state_machine}")
    else
      loginfo("===> Unknown message transmitted = nothing done ! Please, send a known message within calling instance !")
  end
  $evm.instantiate(target_state_machine)
end

############################################################################################################
#		:
#		:		Main Code
#		:

loginfo("---> launch_state_machine starting")

@message = $evm.current_message
@prov = $evm.root['miq_provision'] || $evm.root['vm'].miq_provision

@state_machine_class = get_name(class_tagcat)
@state_machine_instance = get_name(instance_tagcat)

run_state_machine(@state_machine_class, @state_machine_instance)

