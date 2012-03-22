rubyconf {
  ahn_log 'I am inside adhearsion dialplan :-)'
  ahn_log 'destination' 
  dial "DAHDI/g0/9762446921"
  ahn_log 'I am going to quit adhearsion dialplan :-)'
}

from_pstn do
  play "hello", "sandip"
  dial "DAHDI/g0/9762446921"
end
