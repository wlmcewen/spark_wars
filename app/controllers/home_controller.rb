class HomeController < ApplicationController
  def index
    @account = Account.my
  end
end
