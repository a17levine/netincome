class RemoveWrongShitFromBalanceUpdates < ActiveRecord::Migration
  def change
  	remove_column :balance_updates, :tracking
  end
end
