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

urlbase = "https://us.wio.seeed.io/v1/node/GenericDOutD0/high_pulse/%s"
token = ARGV[0]

url = sprintf(urlbase, 300)
res = access(url, token)
puts(res.code)
puts(res.body)
sleep(0.1)

url = sprintf(urlbase, 300)
res = access(url, token)
puts(res.code)
puts(res.body)
