class ExportToRedis
  include UseCasePattern

  validates :hit, presence: true

  def initialize(hit:)
    @hit = hit
  end

  def perform
    redis.lpush("usage_hits", serialised_hit)
    disconnect_redis
  end

  private

  attr_reader :hit

  def redis
    @redis ||= Redis.new(host: "127.0.0.1", port: 6379)
  end

  def disconnect_redis
    redis.quit
    @redis = nil
  end

  def serialised_hit
    JSON.generate(hit.attributes)
  end
end
