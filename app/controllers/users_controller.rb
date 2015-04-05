class UsersController < ApplicationController
  def show
  	@user = User.find(params[:user_id])
  	@thirty_day_income_chart = @user.thirty_day_average_net_income_chart
  end
end
