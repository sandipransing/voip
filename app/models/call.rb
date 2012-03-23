class Call < ActiveRecord::Base
  validates_presence_of :name, :destination
  validates_numericality_of :destination, :allow_blank => true
  
  named_scope :completed, :conditions =>['uniqueid is not ?', nil], :order => 'created_at desc'


  def file
    "#{uniqueid}.wav" if uniqueid
  end

  def path
    "/sound/#{file}" if uniqueid
  end

  def player
    %{<audio src="#{path}" controls="controls">
      Your browser does not support the audio element.
    </audio>} if path
  end 

  def self.find_and_assign_uniqid(e)
    uniqueid = e.headers['Uniqueid']
    call = find_by_uniqueid(uniqueid)
    unless call
      destination = e.headers["Channel"].match(/DAHDI\/i\d\/(\d+)-.+/)[1]
      call = find_by_destination_and_status(destination, nil)
    end
    if call
      call.uniqueid = uniqueid 
      call.status = 'Call is launched'
      call.save(false)
    end
  end

  def self.update_bridge_state(event, dial_status=nil)
    destination = event.headers["Channel2"].match(/DAHDI\/i\d\/(\d+)-.+/)[1]
    uniqueid = event.headers['Uniqueid1']
    call = find_by_uniqueid(uniqueid)
    if call
      call.source = event.headers['Uniqueid2']
      call.status = "#{dial_status} #{destination}"
      call.save(false)
    end
  end
  
  def self.update_new_state(e, dial_status=nil)
    destination = e.headers["Channel"].match(/DAHDI\/i\d\/(\d+)-.+/)[1]
    uniqueid = e.headers['Uniqueid']
    dial_status ||= e.headers['ChannelStateDesc']
=begin
    if e.headers['CallerIDNum'].present?
      a,b = uniqueid.split('.')
      uniqueid = [a, '.', b.to_i-1].join
    end
=end
    call = find_by_uniqueid(uniqueid)
    if call
      call.status = "#{dial_status} #{destination}"
      call.save(false)
    end
    call
  end
end
