require 'pony'
require 'json'
require 'net/http'

email = ARGV[0]
id = ARGV[1..-1]

def get_price(id)
  JSON.parse(Net::HTTP.get(URI("http://p.3.cn/prices/get?skuid=J_#{id}"))).first["p"].to_f
end

def get_url(id)
  "http://item.jd.com/#{id}.html"
end

price = id.each_with_object({}) {|id, h| h[id] = 0}
while true
  price.keys.each do |id|
    new_price = get_price(id)
    Pony.mail(:to => email, :subject => "New price: #{new_price}", :body => get_url(id)) if new_price != price[id]
    price[id] = new_price
  end
  sleep 60
end
