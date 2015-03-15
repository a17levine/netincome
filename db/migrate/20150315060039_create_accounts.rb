class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.references :user, index: true
      t.string :name
      t.string :mint_id

      t.timestamps
    end
  end
end
