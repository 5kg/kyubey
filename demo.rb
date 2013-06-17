require 'pony'
require 'json'
require 'net/http'

email = ARGV[0]
id = ARGV[1..-1].map(&:to_i)

def get_price(id)
  JSON.parse(Net::HTTP.get(URI("http://p.3.cn/prices/get?skuid=J_#{id}"))).first["p"].to_f
end

def get_url(id)
  "http://item.jd.com/#{id}.html"
end

price = Array.new(id.size, 0)
while true
  new_price = id.map {|i| get_price(i)}
  new_price.map.with_index {|p, i| p == price[i] ? nil : i}.each do |i|
    Pony.mail(:to => email, :subject => "New price: #{new_price[i]}", :body => get_url(id[i]))
  end
  price = new_price
  sleep 60
end
