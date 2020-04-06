class SearchController < ApplicationController
  def index
  end

  def search
    redis = Redis.new
    time = DateTime.now.strftime("%Q")
    ip = request.ip
    redis.set(
      "ip:#{ip}:#{time}",
      {
        term: params[:term],
        submit: params[:submit],
        ip: ip,
        sought_at: time,
      }.to_json
    )
    render json: { sucess: true }
  end

  def statistics
    SearchWorker.perform_async
  end
end
