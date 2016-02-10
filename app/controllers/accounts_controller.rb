class AccountsController < ApplicationController
  def index
    @accounts = current_user.accounts
  end

  def new
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end
end
