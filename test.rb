require 'faraday'
require 'pry'

Faraday.post("http://localhost:3000/doctors/check_in_all")

count = 0
no_anomaly = true
while(no_anomaly)
  ids = (1..10)
  threads = ids.map do |id|
    Thread.new do
      response = Faraday.post("http://localhost:3000/doctors/#{id%10+1}/check_out")
    end
  end

  threads.each { |thread| thread.join }

  # check anomaly or reset
  response = Faraday.get("http://localhost:3000/doctors/on_duty")
  on_duty = response.body.to_i

  if on_duty == 0
    p "ITERATION: #{count+=1}  ON_DUTY: #{on_duty} - ANOMALY - ABORT"
    no_anomaly = false
  else
    p "ITERATION: #{count+=1}  ON_DUTY: #{on_duty}"
    Faraday.post("http://localhost:3000/doctors/check_in_all")
  end
end
