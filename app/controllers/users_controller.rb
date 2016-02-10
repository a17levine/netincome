class UsersController < ApplicationController

  def index
  end
  
  def show
  	@user = current_user
    if @user.configured? == false
      redirect_to accounts_path, flash: {info: 'You need to set up accounts first'}
    else
      @balance_chart = @user.balance_chart
      @regression_chart = @user.linear_regression_chart
    end
  end
end
