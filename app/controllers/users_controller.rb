class UsersController < ApplicationController

  def index
  end
  
  def show
  	@user = User.find_by(:uuid => params[:user_uuid])
  	@thirty_day_income_chart = @user.thirty_day_average_net_income_chart
    @balance_chart = @user.balance_chart
  end
end
