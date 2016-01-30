class UsersController < ApplicationController

  def index
  end
  
  def show
  	@user = User.find_by(:uuid => params[:user_uuid])
    @balance_chart = @user.balance_chart
    @regression_chart = @user.linear_regression_chart
  end
end
