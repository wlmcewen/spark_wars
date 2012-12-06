class ListingsController < ApplicationController
  def show
    @account = Account.my
    list_id = params[:id]
     sf = StandardFields.get.first
    @fields = sf.attributes.keys.select { |key| sf.attributes[key]["MlsVisible"].include?('A') }
    @listing = Listing.find(list_id, :_expand => "Photos")
  end
end
