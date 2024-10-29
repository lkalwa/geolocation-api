class CreateGeolocations < ActiveRecord::Migration[7.2]
  def change
    create_table :geolocations do |t|
      t.string :ip
      t.string :url
      t.float :latitude
      t.float :longitude
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
