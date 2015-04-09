class CorrectLastMigrationWithUUidonUsers < ActiveRecord::Migration
  def change
  	remove_column :accounts, :uuid
  	add_column :users, :uuid, :string
  end
end
