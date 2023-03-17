class CreateForecasts < ActiveRecord::Migration[6.0]
  def change
    create_table :forecasts do |t|
      t.string :address
      t.float :temperature
      t.integer :humidity
      t.integer :pressure
      t.float :wind_speed

      t.timestamps
    end
  end
end
