require 'net/https'
class Thingspeak

def initialize(token)
  # curl https://api.thingspeak.com/update/ -X POST -d field1=14 -d field2=45 -H 'X-THINGSPEAKAPIKEY: ※'
  url = 'https://api.thingspeak.com/update/'
  uri = URI.parse(url)
  @https = Net::HTTP.new(uri.host, uri.port)
  @https.use_ssl = true
  
  @req = Net::HTTP::Post.new(uri.request_uri)
  @req["X-THINGSPEAKAPIKEY"] = token
end

# send_thingspeak(data_json)
# data_json = {field1: value1, field2: value2}
def send(data_hash)

  data_array = Array.new
  data_hash.each_pair do |k, v| 
    data_array.push(sprintf("%s=%s", k, v))
  end

  data = data_array.join("&")
  @req.body = data
  res = @https.request(@req)
   
  # 返却の中身を見てみる
#  puts "code -> #{res.code}"
#  puts "msg -> #{res.message}"
#  puts "body -> #{res.body}"

  return (res)
end

end

