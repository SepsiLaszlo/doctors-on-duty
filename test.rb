require 'faraday'

count = 0
ids = (1..10)

while true
  # Setting a consistent environment
  Faraday.post("http://localhost:3000/doctors/check_in_all")

  # Checkout doctors concurrently
  threads = ids.map do |id|
    Thread.new do
      Faraday.post("http://localhost:3000/doctors/#{id}/check_out")
    end
  end

  # Wait for each thread to finish
  threads.each { |thread| thread.join }

  # Fetch and print how many doctors are on duty
  response = Faraday.get("http://localhost:3000/doctors/on_duty")
  on_duty = response.body.to_i
  p "ITERATION: #{count += 1}  ON_DUTY: #{on_duty}"

  # Stop if an anomaly is detected
  p 'ANOMALY' and break if on_duty == 0
end
