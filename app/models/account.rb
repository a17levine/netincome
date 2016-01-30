class Account < ActiveRecord::Base
  belongs_to :user
  has_many :balance_updates, dependent: :destroy

  def balance_on_date(date_object)
    end_of_date = date_object.in_time_zone("Central Time (US & Canada)").end_of_day
    beginning_of_date = date_object.in_time_zone("Central Time (US & Canada)").beginning_of_day
    balance_updates_query_result = self.balance_updates.where('created_at > ? AND created_at < ?', beginning_of_date, end_of_date)
    if balance_updates_query_result.any?
      puts 'found balance updates on account' + self.name
      return balance_updates_query_result.last.amount
    else
      puts 'did not find balance updates on account' + self.name
      return nil
    end
  end

  def last_balance_update_before_date(date_object)
    end_of_date = date_object.in_time_zone("Central Time (US & Canada)").end_of_day
    balance_updates_query_result = self.balance_updates.where('created_at < ?', end_of_date)
    if balance_updates_query_result.any?
      return balance_updates_query_result.last.amount
    else
      return 0
    end
  end
end
