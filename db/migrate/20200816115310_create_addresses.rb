class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.references :building, foreign_key: true
      t.string :city
      t.string :ward
      t.string :line

      t.timestamps
    end
  end
end
