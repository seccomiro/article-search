class SearchController < ApplicationController
  def index
  end

  def search
    redis = Redis.new
    count = redis.incr("count")
    time = DateTime.now.strftime("%Q")
    ip = request.ip
    redis.set(
      "ip:#{ip}:#{time}",
      {
        term: params[:term],
        ip: ip,
        article_count: 0,
        sought_at: time,
      }.to_json
    )
    render json: { sucess: true }
  end

  def statistics
  end
end
