class SearchWorker
  include Sidekiq::Worker

  def perform
    redis = Redis.new
    keys = redis.scan_each(match: "ip:*").to_a.sort
    searches = organize(keys)

    searches.each do |ip, searches|
      if searches.one?
        save_search searches.first["term"]
        next
      end
      searches[0..-2].each_with_index do |s, i|
        next_s = searches[i + 1]
        submit = s["submit"]
        if submit
          save_search s["term"]
          next
        end
        diff = next_s["sought_at"].to_i - s["sought_at"].to_i
        if diff > 3000
          save_search s["term"]
          next
        end
      end
      next_s = searches.last
      diff = next_s["sought_at"].to_i - searches[-2]["sought_at"].to_i
      submit = next_s["submit"]
      save_search next_s["term"] if submit || diff > 3000
    end

    redis.del keys
  end

  private

  def organize(keys)
    redis = Redis.new
    searches = {}
    keys.each do |k|
      ip = k.split(":")[1]
      searches[ip] = [] unless searches[ip]
      searches[ip] << JSON.parse(redis.get(k))
    end
    searches
  end

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
