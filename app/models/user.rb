class User < ActiveRecord::Base
  has_many :accounts
  before_create :create_uuid
  
  def mint_update
    begin
      response = JSON.parse(RestClient.get ENV['MINT_API_SERVER_URL'] + '/get_mint', {:params => {:u => self.mint_u, :p => self.mint_p}})
      @accounts = []
      response.each do |account|
        if account["accountSystemStatus"] && account["accountSystemStatus"] == "ACTIVE"
          a = self.accounts.find_or_create_by(:mint_id => account["accountId"].to_s)
          unless a.name
            a.name = account["fiLoginDisplayName"]
            puts "Updating #{self.name} account #{account['fiLoginDisplayName']}"
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
    if @relevant_account_updates.any?
      @accounts_to_track.each do |account_id|
        account_relevant_updates = @relevant_account_updates.select { |au| au.account_id == account_id }
        account_relevant_updates.sort_by &:created_at
        if account_relevant_updates.any? == true
          max_amount = account_relevant_updates[-1].amount
          min_amount = account_relevant_updates[0].amount
          difference = max_amount - min_amount
          @difference += difference
        end
      end
    end
    return @difference
  end

  def get_difference_per_day(start_time, end_time)
    @days_elapsed = (end_time.to_i - start_time.to_i) / 1.day
    get_difference(start_time, end_time) / @days_elapsed
  end

  def get_linear_regression_slope(start_time, end_time)
    lineFit = LineFit.new
    @accounts_to_track = self.accounts.map { |a| a.id }
    @relevant_account_updates = BalanceUpdate.where("created_at >= :start_time AND created_at <= :end_time",
  {start_time: start_time, end_time: end_time}).where(:account_id => @accounts_to_track).order(:created_at)
    x_coordinate_start_date = start_time
    slopes = []
    @accounts_to_track.each do |account_id|
      y_coordinates = []
      x_coordinates = []
      account_relevant_updates = @relevant_account_updates.select { |au| au.account_id == account_id }
      account_relevant_updates.sort_by &:created_at
      if account_relevant_updates.any?
        account_relevant_updates.each do |account_relevant_update|
          x_coordinates << (account_relevant_update.created_at - x_coordinate_start_date) / 1.day
          y_coordinates << account_relevant_update.amount
        end
        lineFit.setData(x_coordinates,y_coordinates)
        intercept, slope = lineFit.coefficients
        slopes << slope
      end
    end
    slopes.sum
  end

  def thirty_day_average_net_income_chart
    @labels = []
    @data = []
    30.times do |i|
      start_time = Time.now - (30 + i).days
      end_time = Time.now - i.days
      @labels << end_time.strftime("%b%e")
      @data << get_linear_regression_slope(start_time, end_time).round(0)
    end
    return {
      :data => @data.reverse!,
      :labels => @labels.reverse!
    }
  end
  
  def name
    "#{self.first_name} #{self.last_name}"
  end


  private

  def create_uuid
    begin
      self.uuid = SecureRandom.uuid
    end while self.class.exists?(:uuid => uuid)
  end
end
