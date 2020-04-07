class SearchController < ApplicationController
  def index
  end

  def search
    @articles = Article.where("title LIKE ?", "%#{params[:term]}%")

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
        article_count: @articles.count
      }.to_json
    )

    respond_to do |format|
      format.json { render json: @articles, :only => [:id, :title] }
    end
  end

  def statistics
    @searches = Search.order(count: :desc)
  end
end
