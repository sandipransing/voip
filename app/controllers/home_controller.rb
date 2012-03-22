require 'drb'
class HomeController < ApplicationController
  before_filter :load_drb, :only => :dial
  before_filter :load_call, :only => [:poll]

  def records
    @calls = Call.completed.pagination(params)
  end

  def dial
    raise unless @adhearsion
    @call.attributes = params[:call]
    @call ||= Call.find_by_destination_and_status(@call.destination, nil)
    if @call.valid?
      @adhearsion.originate({
        :channel   => "DAHDI/g0/#{@call.destination}", 
        :context   => "rubyconf", 
          :exten   => '9021',
          :priority  => 1,
          :callerid  => "02066819021",
          :async => 'true',                                     
          :variable  => "call_launcher=true|sleep_time=3600|destination=#{@call.destination}"})
       @call.save
    end
    render :action => :index
  rescue
    flash[:error] = "Adhearsion is not started"
    redirect_to root_url
  end

  def index
    @call = Call.new
  end

  def play
  end

  def poll
    
    render :update do |page|
      if @call.status.present?
        page.replace_html 'result', :partial => 'result'
      else
        render :nothing => true
      end
    end
  end

  private

  def load_drb
    # Call.destroy_all
    @adhearsion = DRbObject.new_with_uri "druby://localhost:9092"
    @call = Call.new
  end

  def invalid_url!
    if request.xhr?
      render :nothing => true
    else
      flash[:notice] = "Invalid URL!"
      redirect_to(root_url) and return
    end
  end

  def load_call
    @call = Call.find_by_id(params[:id])
    @call || invalid_url!
  end
end
