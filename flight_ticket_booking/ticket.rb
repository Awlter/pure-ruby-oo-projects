class Ticket
  attr_reader :flight, :price, :sched

  def initialize(flight, price, sched)
    @flight = flight
    @price = price
    @sched = sched
  end

  def ==(another)
    price == another.price
  end

  def better_than?(another)
    hour_of_self = sched.split(':')[0].to_i
    hour_of_another = another.sched.split(':')[0].to_i
    return true if (hour_of_self - 12).abs <= 1
    return false if (hour_of_another - 12).abs <= 1
    hour_of_self < hour_of_another
  end
end