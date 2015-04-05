class User < ActiveRecord::Base
  has_many :accounts

  def mint_update
    begin
      response = JSON.parse(RestClient.get ENV['MINT_API_SERVER_URL'] + '/get_mint', {:params => {:u => self.mint_u, :p => self.mint_p}})
      @accounts = []
      response.each do |account|
        if account["accountSystemStatus"] && account["accountSystemStatus"] == "ACTIVE"
          a = self.accounts.find_or_create_by(:mint_id => account["accountId"].to_s)
          unless a.name
            a.name = account["fiLoginDisplayName"]
            puts "Updating #{self.name}"
            a.save
          end
          a.balance_updates.create(:amount => account["value"])
        end
      end
    rescue => e
      puts "Mint couldn't be reached. Error below."
      puts e
    end
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end
end
