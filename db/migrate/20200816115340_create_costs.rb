class CreateCosts < ActiveRecord::Migration[5.0]
  def change
    create_table :costs do |t|
      t.references :building, foreign_key: true
      t.integer :rent, default: 0
      t.integer :administration_fee, dafault: 0
      t.integer :set_deposit, default: 0
      t.integer :reward, default: 0
      t.integer :bond_payment, default: 0
      t.integer :repayment, default: 0
      t.integer :commission, default: 0

      t.timestamps
    end
  end
end
