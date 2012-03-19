require 'drb'
class HomeController < ApplicationController
  before_filter :load_drb
  
  def index
    if params[:number].present?
      @adhearsion.originate({
        :channel   => "DAHDI/g0/#{params[:number]}", 
        :context   => "rubyconf", 
        :exten   => '9121',
        :priority  => 1,
        :callerid  => "66839121",
        :data => params[:number],
        :async => 'true',                                     
        :variable  => "call_launcher=true|sleep_time=3600" })
    end
  rescue
    flash[:notice] = "Adhearsion is not started"
    redirect_to root_url
  end

  private

  def load_drb
    @adhearsion = DRbObject.new_with_uri "druby://localhost:9092"
  end

end
