require 'net/https'
require 'json'

# GenericDOutD0
# GroveOLED12864I2C1
# Grove4DigitUART0

module Wionode_GenericDOutD
  # GenericDOutD0/high_pulse/[msec]
  def high_pulse(msec)
    urlbase = sprintf(@urlbase+"GenericDOutD0/high_pulse/%s", msec)
    res = access(url)
  end
  
end

module Wionode_GroveOLED12864I2C
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

module Wionode_Grove4DigitUART
  # Grove4DigitUART0
  def check_Grove4DigitUART()
    port = @device.index("Grove4DigitUART")
    raise if (port == nil)

    return(port)
  end

  def clear()
    port = check_Grove4DigitUART()
    url = sprintf("%sGrove4DigitUART%d/clear", @urlbase, port)
    res = access(url)
  end

  def point_on()
    port = check_Grove4DigitUART()
    url = sprintf("%sGrove4DigitUART%d/display_point/1", @urlbase, port)
    res = access(url)
  end

  def point_off()
    port = check_Grove4DigitUART()
    url = sprintf("%sGrove4DigitUART%d/display_point/0", @urlbase, port)
    res = access(url)
  end

  # chars: 0,1,2,3,4,5,6,7,8,9,A,b,C,d,E,F,V,U
  def digits(pos, chars)
    port = check_Grove4DigitUART()
    url = sprintf("%sGrove4DigitUART%d/display_digits/%s/%s", @urlbase, port, pos, chars)
    res = access(url)
  end

  # chars: 0,1,2,3,4,5,6,7,8,9,A,b,C,d,E,F,V,U
  def digit1(pos, char)
    port = check_Grove4DigitUART()
    url = sprintf("%sGrove4DigitUART%d/display_one_digit/%s/%s", @urlbase, port, pos, chars)
    res = access(url)
  end

  # level: 0,2,7
  def bright(level)
    port = check_Grove4DigitUART()
    url = sprintf("%sGrove4DigitUART%d/brightness/%s", @urlbase, port, level)
    res = access(url)
  end
end

module Wionode_GroveGestureI2C
  # Grove4DigitUART0
  def gesture_read()
    url = @urlbase+"GroveGestureI2C1/motion"
    # res.body.motion
    # 1-right, 2-left, 3-up, 4-down, 5-forward, 6-backward, 7-clockwise, 8-countclockwise, 255-sensor initialization fail
    res = access(url)
  end
end

module Wionode_GroveTempHumProD
  def check_GroveTempHumProD()
    port = @device.index("GroveTempHumProD")
    raise if (port == nil)

    return(port)
  end

  def humidity()
    port = check_GroveTempHumProD()
    url = sprintf("%sGroveTempHumProD%d/humidity", @urlbase, port)
    res = access_get(url)

    data = JSON.parse(res.body)
    return (data["humidity"])
  end

  def temperature()
    port = check_GroveTempHumProD()
    url = sprintf("%sGroveTempHumProD%d/temperature", @urlbase, port)
    res = access_get(url)

    data = JSON.parse(res.body)
    return (data["celsius_degree"])
  end
end

class Wionode
  include Wionode_GenericDOutD
  include Wionode_GroveOLED12864I2C
  include Wionode_Grove4DigitUART
  include Wionode_GroveGestureI2C
  include Wionode_GroveTempHumProD

  def check_device_available(device)
    devices = [
      "GenericDOutD",
      "GroveOLED12864I2C",
      "Grove4DigitUART",
      "GroveGestureI2C",
      "GroveTempHumProD",
      nil
    ]

    raise if (devices.index(device) == nil)
  end

  def initialize(device0, device1, token, urlhost="us.wio.seeed.io")
    check_device_available(device0)
    check_device_available(device1)

    @device = Array.new
    @device[0] = device0
    @device[1] = device1

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

  def access_get(url)
    uri = URI.parse(url+"?access_token="+@token)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.request_uri)
    res = http.request(req)
  
    return(res)
  end
end

