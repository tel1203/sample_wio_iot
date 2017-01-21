require 'net/https'

# GenericDOutD0
# GroveOLED12864I2C1
# Grove4DigitUART0

module Wionode_GenericDOutD0
  # GenericDOutD0/high_pulse/[msec]
  def high_pulse(msec)
    urlbase = sprintf(@urlbase+"GenericDOutD0/high_pulse/%s", msec)
    res = access(url)
  end
  
end

module Wionode_GroveOLED12864I2C1
  # GroveOLED12864I2C1/clear
  def clear()
    url = @urlbase+"GroveOLED12864I2C1/clear"
    res = access(url)
  end
  
  # GroveOLED12864I2C1/base64_string/[row]/[col]/[b64_str]
  require 'base64'
  def text(row, col, text)
    text = Base64.encode64(text)
    url = sprintf(@urlbase+"GroveOLED12864I2C1/base64_string/%s/%s/%s", row, col, text)
    res = access(url)
  end
end

module Grove4DigitUART0
  # Grove4DigitUART0
  def clear()
    url = @urlbase+"Grove4DigitUART0/clear"
    res = access(url)
  end

  def point_on()
    url = @urlbase+"Grove4DigitUART0/display_point/1"
    res = access(url)
  end

  def point_off()
    url = @urlbase+"Grove4DigitUART0/display_point/0"
    res = access(url)
  end

  # chars: 0,1,2,3,4,5,6,7,8,9,A,b,C,d,E,F,V,U
  def digits(pos, chars)
    url = sprintf(@urlbase+"Grove4DigitUART0/display_digits/%s/%s", pos, chars)
    res = access(url)
  end

  # chars: 0,1,2,3,4,5,6,7,8,9,A,b,C,d,E,F,V,U
  def digit1(pos, char)
    url = sprintf(@urlbase+"Grove4DigitUART0/display_one_digit/%s/%s", pos, char)
    res = access(url)
  end

  # level: 0,2,7
  def bright(level)
    url = sprintf(@urlbase+"Grove4DigitUART0/brightness/%s", level)
    res = access(url)
  end
end

module GroveGestureI2C1
  # Grove4DigitUART0
  def gesture_read()
    url = @urlbase+"GroveGestureI2C1/motion"
    # res.body.motion
    # 1-right, 2-left, 3-up, 4-down, 5-forward, 6-backward, 7-clockwise, 8-countclockwise, 255-sensor initialization fail
    res = access(url)
  end
end

module GroveTempHumProD0
  def humidity()
    url = @urlbase+"GroveTempHumProD0/humidity"
    res = access(url)
  end

  def temperature()
    url = @urlbase+"GroveTempHumProD0/temperature"
    url = @urlbase+"GroveTempHumProD0/temperature?access_token=8c368493de470a0098231daf355ecdbc"
    res = access(url)
  end
end

class Wionode
  include Grove4DigitUART0
  include GroveGestureI2C1
  include GroveTempHumProD0

  def initialize(token, urlhost="us.wio.seeed.io")
    @token = token
    @urlbase = "https://"+urlhost+"/v1/node/"
  end

  # Sleep Wionode in specific seconds
  def sleep(sec)
    url = sprintf($urlbase+"pm/sleep/%s", sec)
    res = access(url)

    return (res)
  end

  # Access to Wio server
  def access(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data({'access_token' => @token})
    res = http.request(req)
  
    return(res)
  end
end

