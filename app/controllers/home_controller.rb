class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @establishments = Establishment.order(rating: :desc).limit(10)
    @categories = Category.all
  end
end
