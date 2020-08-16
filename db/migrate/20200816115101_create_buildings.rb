class CreateBuildings < ActiveRecord::Migration[5.0]
  def change
    create_table :buildings do |t|
      t.string :suumo_number
      t.string :floor
      t.integer :area
      t.integer :age
      t.references :structure, foregin_key: true

      t.timestamps
    end
  end
end
