class AddIndexToGeolocationsIpAndUrl < ActiveRecord::Migration[7.2]
  def change
    add_index :geolocations, :ip
    add_index :geolocations, :url
  end
end
