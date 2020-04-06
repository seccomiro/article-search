class SearchWorker
  include Sidekiq::Worker

  def perform
    redis = Redis.new
    keys = redis.scan_each(match: "ip:*").to_a.sort

    last = {}
    keys.each do |k|
      current = JSON.parse redis.get(k)
      if last.ip == current.ip
        diff = current.sought_at - last.sought_at
        if diff > 3000
          save_search current.term
          last = {}
        end
      else
        save_search last.term
        last = current
      end
    end
  end

  private

  def save_search(term)
    search = Search.find_by_term(term)
    if search
      search.count += 1
      search.save
    else
      search = Search.create(term: term, count: 1)
    end
    search
  end
end
