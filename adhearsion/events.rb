##
# In this file you can define callbacks for different aspects of the framework. Below is an example:
##
#
# events.asterisk.before_call.each do |call|
  # This simply logs the extension for all calls going through this Adhearsion app.
  # extension = call.variables[:extension]
  # ahn_log "Got a new call with extension #{extension}"
# end

##
# Asterisk Manager Interface example:
#
events.asterisk.manager_interface.each do |event|
  #  ahn_log.events event.name
  #status = event.headers["ChannelStateDesc"]
  #puts "#{event.name} #{destination} #{uniqueid} - #{status}**"

  puts event.name
  case event.name
  when 'VarSet'
    case event['Variable']
    when 'call_launcher'
      Call.find_and_assign_uniqid(event)
    end
  when 'Newexten'
  when 'Newchannel'
  when 'Newstate'
    case event.headers['ChannelStateDesc']
    when 'Dialing'
     # Call.update_new_state(event)
    when 'Ringing'
      Call.update_new_state(event)
    when 'Up'
       Call.update_new_state(event, 'answered')
    end
  when "Monitor"
  when 'Dial'
    status = 'Dialing Me 9762446921'
  when "Bridge"
    Call.update_bridge_state(event, 'Bridge')
  when "Unlink"
    status = "Call disconnected"
  when "MonitorStart"
    status = "Call recording has been started"
  when "Hangup"
    puts event.inspect
    Call.update_new_state(event, 'Hangup')
  when "MonitorStop"
  end

end
# This assumes you gave :events => true to the config.asterisk.enable_ami method in config/startup.rb
#
##
# Here is a list of the events included by default:
#
# - events.asterisk.manager_interface
# - events.after_initialized
# - events.shutdown
# - events.asterisk.before_call
# - events.asterisk.failed_call
# - events.asterisk.hungup_call
#
#
# Note: events are mostly for components to register and expose to you.
##
