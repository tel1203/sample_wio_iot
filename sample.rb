require 'net/https'

token = ARGV[0]

# URL for WIO node API
url = "https://us.wio.seeed.io/v1/node/GenericDOutD0/high_pulse/300"
url = "https://us.wio.seeed.io/v1/node/GenericAInA0/analog"
url = "https://us.wio.seeed.io/v1/node/GroveSpeakerD0/sound_ms/800/100"

# Create HTTP request
uri = URI.parse(url)
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true

# Add access_token to Request
req = Net::HTTP::Post.new(uri.path)
req.set_form_data({'access_token' => token})

# Send Request
res = http.request(req)
puts(res.code)
puts(res.body)


