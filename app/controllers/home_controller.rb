class HomeController < ApplicationController
  def index
    @account = Account.my
    @listings = Listing.find(:all, :_filter => "ListPrice Lt 500000.0 And ListPrice Gt 100000.0 And PropertyType Eq 'A' And MlsStatus Eq 'Active'")
  end
end
