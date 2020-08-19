class CreateStations < ActiveRecord::Migration[5.0]
  def change
    create_table :stations do |t|
      t.references :building, foreign_key: true
      t.string :line
      t.string :name
      t.integer :walk

      t.timestamps
    end
  end
end
