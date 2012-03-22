##
# In this file you can define callbacks for different aspects of the framework. Below is an example:
##
#
events.asterisk.before_call.each do |call|
  # This simply logs the extension for all calls going through this Adhearsion app.
  #extension = call.variables[:extension]
  #ahn_log "Got a new call with extension #{extension}"
end

##
# Asterisk Manager Interface example:
#
events.asterisk.manager_interface.each do |event|
  puts "***#{event.inspect}"
  #  ahn_log.events event.name
  channel = event.headers["Channel"]
  channel.match(/DAHDI\/i\d\/(\d+)-.+/)
  destination = $1
  puts destination
  uniqueid = event.headers['Uniqueid']
  call = Call.find_by_uniqueid(uniqueid)
  call ||= Call.find_by_destination_and_status(destination, nil)
  call.uniqueid = uniqueid
  status = event.headers["ChannelStateDesc"]
  #puts "#{event.name} #{destination} #{uniqueid} - #{status}**"

  case event.name
  when 'Newexten'
    #puts event.inspect
  when 'Newchannel'
    status = "Dialing #{destination}"
  when "Newstate"
    status = "#{event.headers["ChannelStateDesc"]} #{destination}"
  when 'Dial'
    status = 'Dialing Me 9762446921'
  when "Bridge"
    status = "Call connected"
  when "Unlink"
    status = "Call disconnected"
  when "MonitorStart"
    status = "Call recording has been started"
  when "Hangup"
    status = "Call Hangup"
  when "MonitorStop"
    status = "Call recording has stopped"
  end if call

  if call
    call.status = status if status.present?
    if call.changes['status'] || call.changes['uniqueid']
      #puts call.status
      call.save(false)
    end
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
