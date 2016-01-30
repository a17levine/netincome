class Account < ActiveRecord::Base
  belongs_to :user
  has_many :balance_updates, dependent: :destroy
end
