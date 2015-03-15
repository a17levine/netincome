class CreateBalanceUpdates < ActiveRecord::Migration
  def change
    create_table :balance_updates do |t|
      t.references :account, index: true
      t.integer :amount

      t.timestamps
    end
  end
end
