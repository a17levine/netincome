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

  def get_difference(start_time, end_time)
    @difference = 0.0
    @accounts_to_track = self.accounts.map { |a| a.id }
    @relevant_account_updates = BalanceUpdate.where("created_at >= :start_time AND created_at <= :end_time",
  {start_time: start_time, end_time: end_time}).where(:account_id => @accounts_to_track).order(:created_at)
    @accounts_to_track.each do |account_id|
      account_relevant_updates = @relevant_account_updates.select { |au| au.account_id == account_id }
      account_relevant_updates.sort_by &:created_at
      max_amount = account_relevant_updates[-1].amount
      min_amount = account_relevant_updates[0].amount
      difference = max_amount - min_amount
      @difference += difference
    end
    return @difference
  end

  def get_difference_per_day(start_time, end_time)
    @days_elapsed = (end_time.to_i - start_time.to_i) / 1.day
    get_difference(start_time, end_time) / @days_elapsed
  end

  # def thirty_day_average_net_income_chart
  #   return {
  #     :data => [45, 46]
  #     :labels => ['Date1', 'Date2']
  #   }
  # end
  
  def name
    "#{self.first_name} #{self.last_name}"
  end
end
