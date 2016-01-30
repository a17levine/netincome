class Account < ActiveRecord::Base
  belongs_to :user
  has_many :balance_updates, dependent: :destroy

  def balance_on_date(date_object)
    end_of_date = date_object.in_time_zone("Central Time (US & Canada)").end_of_day
    beginning_of_date = date_object.in_time_zone("Central Time (US & Canada)").beginning_of_day
    balance_updates_query_result = self.balance_updates.where('created_at > ? AND created_at < ?', beginning_of_date, end_of_date)
    if balance_updates_query_result.any?
      balance_updates_query_result.last.amount
      puts 'found balance updates on account' + self.name
    else
      puts 'did not find balance updates on account' + self.name
      nil
    end
  end
end
