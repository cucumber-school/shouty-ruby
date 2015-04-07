class Person
  attr_reader :messages_heard, :location
  attr_accessor :credits

  def initialize(network, location)
    network.subscribe(self)
    @network, @location = network, location
    @messages_heard = []
    @credits = 0
  end

  def shout(message)
    return unless can_afford?(message)
    deduct_credits(message)
    @network.broadcast(message, self)
  end

  def hear(message)
    messages_heard << message
  end

  private

  def can_afford?(message)
    cost_of(message) <= @credits
  end

  def deduct_credits(message)
    @credits -= cost_of(message)
  end

  def cost_of(message)
    cost = 0
    if message.length > 180
      cost += 2
    end
    message.scan(/buy/i).each do
      cost += 5
    end
    cost
  end

end

class Network
  def initialize(range)
    @range = range
    @listeners = []
  end

  def subscribe(listener)
    @listeners << listener
  end

  def broadcast(message, shouter)
    shouter_location = shouter.location
    @listeners.each do |listener|
      within_range = (listener.location - shouter_location).abs <= @range
      if within_range
        listener.hear message
      end
    end
  end

end
