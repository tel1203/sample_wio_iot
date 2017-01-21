require 'net/https'

def access(url, token)
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  req = Net::HTTP::Post.new(uri.path)
  req.set_form_data({'access_token' => token})
  res = http.request(req)

  return(res)
end

$urlbase0 = "https://us.wio.seeed.io/v1/node/pm/"
$urlbase1 = "https://us.wio.seeed.io/v1/node/GenericDOutD0/"
$urlbase2 = "https://us.wio.seeed.io/v1/node/GroveOLED12864I2C1/"
$token = ARGV[0]

# GenericDOutD0/high_pulse/[msec]
def func11(msec)
  url = sprintf($urlbase1+"high_pulse/%s", msec)
  res = access(url, $token)
end

# GroveOLED12864I2C1/clear
def func21()
  url = sprintf($urlbase2+"clear")
  res = access(url, $token)
end

# GroveOLED12864I2C1/base64_string/[row]/[col]/[b64_str]
require 'base64'
def func22(row, col, text)
  text = Base64.encode64(text)
  url = sprintf($urlbase2+"base64_string/%s/%s/%s", row, col, text)
  res = access(url, $token)
end

def func0(sec)
  url = sprintf($urlbase0+"sleep/%s", sec)
  res = access(url, $token)
end

#func11(300)

func21()
func22(0,0, "192.168.000.001")
func22(1,0, "Teruaki Yokoyama")
func22(2,0, "192.168.000.001")
func0(3)

