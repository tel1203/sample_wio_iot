require './Wionode.rb'

def calc_waitingtime(hour, min)
  # 平日 若葉町バス停→阪神芦屋駅
  timetable = Hash.new
  timetable["weekday"] = Hash.new
  timetable["weekend"] = Hash.new
  
  timetable["weekday"][5] = [ 54 ]
  timetable["weekday"][6] = [ 04, 24, 11, 40, 45, 34, 52 ]
  timetable["weekday"][7] = [ 01, 51, 45, 15, 23, 35, 04, 14, 24, 34, 44, 54]
  timetable["weekday"][8] = [ 03, 10, 36, 52, 31, 25, 44, 15, 04, 14, 24, 34, 42]
  timetable["weekday"][9] = [ 24, 44,  9, 32, 49, 01]
  timetable["weekday"][10] = [ 44, 06, 32, 49, 18]
  timetable["weekday"][11] = [ 44, 06, 32, 54, 18, 49]
  timetable["weekday"][12] = [ 44, 06, 32, 54, 18]
  timetable["weekday"][13] = [ 44, 06, 32, 54, 18, 49]
  timetable["weekday"][14] = [ 44, 06, 32, 54, 18]
  timetable["weekday"][15] = [ 44, 06, 32, 54, 18, 48]
  timetable["weekday"][16] = [ 42, 54, 06, 34, 45, 18]
  timetable["weekday"][17] = [ 18, 54, 04, 30, 48]
  timetable["weekday"][18] = [ 47, 03, 33, 18,  8]
  timetable["weekday"][19] = [ 02, 17, 32, 49]
  timetable["weekday"][20] = [ 57,  9, 49, 29, 15]
  timetable["weekday"][21] = [ 29]
  timetable["weekday"][22] = [ 12, 23, 53]
  
                             # XX, XX, XX | XX, XX | XX, XX | XX, XX, XX | XX | XX
  timetable["weekend"][ 6] = [ 00, 25, 58,  10, 44,           33 ]
  timetable["weekend"][ 7] = [ 26,          12,               41,          50 ]
  timetable["weekend"][ 8] = [ 01,          17, 34,           23, 45,      54 ]
  timetable["weekend"][ 9] = [ 44,          07, 32,  49,      18 ]
  timetable["weekend"][10] = [ 44,          07, 32,  49,      18,               30 ]
  timetable["weekend"][11] = [ 44,          07, 32,  54,      18 ]
  timetable["weekend"][12] = [ 44,          07, 32,  54,      18,               43 ]
  timetable["weekend"][13] = [ 44,          07, 32,  54,      18 ]
  timetable["weekend"][14] = [ 44,          07, 32,  54,      18,               38 ]
  timetable["weekend"][15] = [ 44,          07, 32,  54,      18 ]
  timetable["weekend"][16] = [              07, 29,  37, 52,  21,               37 ]
  timetable["weekend"][17] = [ 44,          07, 25,           20, 39,           58 ]
  timetable["weekend"][18] = [              14, 27,           01, 24, 51 ]
  timetable["weekend"][19] = [ 58,          07, 34,           21, 51 ]
  timetable["weekend"][20] = [ 58,           9, 48,  29 ]
  timetable["weekend"][21] = [ 26 ]
  timetable["weekend"][22] = [                        8 ]
  
  t = Time.now
  
  if (t.wday != 0 and t.wday != 6) then
      # weekday
      table = timetable["weekday"]
  else
      # weekend
      table = timetable["weekend"]
  end
  
  min0 = hour*60 + min
  
  hours =  table.keys.sort {|a, b| b <=> a }
  min_last = 0
  hours.each do |hour|
    mins = table[hour].sort {|a, b| b <=> a }
    mins.each do |min|
      min1 = hour*60 + min
      #printf("!%2s:%2s %d\n", hour, min, min1)
      break if (min0 > min1)
      min_last = min1
    end
  end

  if (min_last == 0) # after last bus
      min_last = calc_waiting(0, 0) + 24*60 # suggest earlist bus at next day
  end

  min0 = hour*60+min
  wait = min_last - min0

  return (wait)
end

# Calc waiting time
t = Time.now
#printf("%02s:%02s\n", t.hour, t.min)

wait = calc_waitingtime(t.hour, t.min)
#printf("%d\n", wait)

# Print waiting time
token = ARGV[0]
n = Wionode.new("Grove4DigitUART", "GroveTempHumProD", token)

n.bright(2)
n.point_off()
n.digits(0, sprintf("%04d", wait))

#p n.temperature()
#p n.humidity()

