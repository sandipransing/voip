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

end
