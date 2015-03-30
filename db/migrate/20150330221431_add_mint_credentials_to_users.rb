class AddMintCredentialsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :mint_u, :string
    add_column :users, :mint_p, :string
  end
end
