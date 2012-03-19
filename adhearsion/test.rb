require 'drb'
@adhearsion = DRbObject.new_with_uri "druby://localhost:9092"
#@adhearsion.introduce("DAHDI/g0/9762446921", "DAHDI/g0/8087144036")
result = @adhearsion.originate({ :channel   => "DAHDI/g0/9762446921", 
                               :context   => "rubyconf", 
                               :exten   => '7524',
                               :priority  => 1,
                               :callerid  => "66837424",
                               :data => '9975773744',
                               :async => 'true',                                     
                               :variable  => "call_launcher=true|sleep_time=3600" })
