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
          # Final search detected
          # Save current to DB
          last = {}
        end
      else
        # IP change detected
        # Save last to DB
        last = current
      end
    end
  end
end
