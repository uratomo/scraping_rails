class CreateStructures < ActiveRecord::Migration[5.0]
  def change
    create_table :structures do |t|
      t.string :name, uniq: true

      t.timestamps
    end
  end
end
