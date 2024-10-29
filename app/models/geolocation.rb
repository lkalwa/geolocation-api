class Geolocation < ApplicationRecord

  validates_presence_of :city, :country, :latitude, :longitude
  validates_presence_of :ip, if: -> { url.blank? }
  validates_presence_of :url, if: -> { ip.blank? }
end
