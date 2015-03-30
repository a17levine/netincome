class ChangeBalanceUpdatesAmountToFloat < ActiveRecord::Migration
  def change
    change_column :balance_updates, :amount, :float
  end
end
