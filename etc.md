Really awesome query for balance updates.

BalanceUpdate.where(:account_id => User.first.accounts.map{|a| a.id})