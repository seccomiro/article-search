class SearchController < ApplicationController
  def index
  end

  def search
    redis = Redis.new
    count = redis.incr("count")
    redis.set(
      count,
      {
        term: params[:term],
        ip: request.ip,
        article_count: 0,
        sought_at: DateTime.now.strftime("%Q"),
      }.to_json
    )
    render json: { sucess: true, count: count }
  end

  def statistics
  end
end
