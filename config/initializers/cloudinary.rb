require 'dotenv/load'

Cloudinary.config do |config|
  config.cloud_name = 'dis2k0keq'
  config.api_key = '578344134129924'
  config.api_secret = ENV['CLOUDINARY_SECRET']
  config.secure = true
  config.cdn_subdomain = true
end
