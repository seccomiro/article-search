class SearchController < ApplicationController
  def index
  end

  def search
    render json: { sucess: true }
  end
end
