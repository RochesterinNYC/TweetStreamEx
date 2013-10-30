class HardWorker
  include Sidekiq::Worker
  def perform(name, count)
    puts "hey"
  end
end
