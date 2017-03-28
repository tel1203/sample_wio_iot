require './Wionode.rb'
require './Thingspeak.rb'

# Wio node
token = ARGV[0]
n = Wionode.new("Grove4DigitUART", "GroveTempHumProD", token)
temp = n.temperature()
humi = n.humidity()

# Thingspeak
token_thingspeak = ARGV[1]
field1 = ARGV[2]
field2 = ARGV[3]
t = Thingspeak.new(token_thingspeak)
data = Hash.new
data[field1] = temp
data[field2] = humi
res = t.send(data)
 
# 返却の中身を見てみる
puts token
puts Time.now
puts "code -> #{res.code}"
puts "msg -> #{res.message}"
puts "body -> #{res.body}"

