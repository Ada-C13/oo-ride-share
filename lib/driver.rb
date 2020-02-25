require 'Time'

atime = Time.parse("2018-12-27 02:39:05 -0800")

puts atime.class
puts atime.hour
puts atime.zone

btime = Time.parse("2018-12-27 4:39:05 -0800")
puts btime - atime

puts atime > btime