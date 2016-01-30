namespace :setup do
  desc "Setting up all balance updates for all users"
  task all: :environment do
    Account.destroy_all
    User.destroy_all
    scatman = User.create(first_name: 'Scatman', last_name: 'John')
    credit_card = scatman.accounts.create(name: 'Scatman Visa', tracking: true)
    checking_acct = scatman.accounts.create(name: 'Scatman Checking', tracking: true)
    time = Time.now - 360.days
    cc_balance = 0
    checking_balance = 10000
    360.times do |iteration|
      credit_card.balance_updates.create(amount: cc_balance, created_at: time)
      puts "Creating credit card update #{cc_balance} on #{time}"
      checking_acct.balance_updates.create(amount: checking_balance, created_at: time)
      puts "Creating checking_acct update #{checking_balance} on #{time}"
      time = time + 1.days
      if iteration % 30 == 0
        # Pay off the credit card
        checking_balance = checking_balance + cc_balance
        cc_balance = 0
      end
      cc_balance = cc_balance - (100 + SecureRandom.random_number(20))
      checking_balance = checking_balance + (120 + SecureRandom.random_number(20))
    end
  end

end
