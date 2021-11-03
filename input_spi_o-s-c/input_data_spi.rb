# nlb -- 18-10-2021
# open stage control : https://openstagecontrol.ammd.net/download/
# User type some special words into an input field from open stage control
# then sonic pi triggers actions
# o-s-c in this document is for the long word open-stage-control :-)

# o-s-c is installed on the same host, same pc and receive osc messages on port 7777
use_osc "127.0.0.1" , 7777

# to display the available words
set :default_msg, "Type one of these words :
roll, crow, piano, jingle"

# Get the user attention
messages = (ring "Hey you !",
            "Sonic Pi is talking to you",
            get[:default_msg])

use_bpm 60

(messages.length).times do
  # we send to o-s-c
  osc "/msg", messages.tick
  sleep 2 # 2 seconds as  bpm set to 60
end
# reset the input field
osc "/msg/input", "  "


define :jingle do
  use_bpm 240
  use_synth :pretty_bell
  n = scale :c, :diminished2
  
  use_octave +1
  8.times do
    play n.pick, pan: [-1,1].tick
    sleep 0.25
    
  end
end


live_loop :detectUserInput do
  use_real_time
  n, v = sync "/osc:127.0.0.1:7777/msg/input"
  puts "I received a msg !"
  puts n
  
  case n
  
  when "roll"
    sample :drum_roll
    sleep 1
    
  when "crow"
    sample :misc_crow
    sleep 1
    
  when "piano"
    use_synth :piano
    use_bpm 120
    
    s = scale :c, 'major'
    (s.length).times do
      play s.tick
      sleep 0.25
    end
    
  when "jingle"
    jingle
    
    
  else
    2.times do
      sample :bass_drop_c, finish: 0.15, rate: -2
      sleep 0.25
    end
    
    osc "/msg", "hum i don't know what to do"
    sleep 2
    osc "/msg", get[:default_msg]
    sleep 1
    
    
  end
end