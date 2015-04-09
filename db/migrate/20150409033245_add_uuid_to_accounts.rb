class AddUuidToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :uuid, :string
  end
end
