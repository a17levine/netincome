class AddTrackingToBalanceUpdates < ActiveRecord::Migration
  def change
    add_column :balance_updates, :tracking, :boolean, { default: true }
  end
end
