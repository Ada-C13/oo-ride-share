require 'time'

def time_difference(time_a, time_b)
  difference = Time.parse(time_b) - Time.parse(time_a)

  if difference > 0
    return difference
  else
    return  24 * 3600 + difference
  end
end

end_time = "2018-12-27 03:38:08 -0800"
start_time = "2018-12-27 02:39:05 -0800"

puts time_difference(start_time, end_time)