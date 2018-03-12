require_relative 'ticket'

FLIGHT_PRICES = {
  'GD2501' => {
    'WEEKDAYS' => { 'REGULAR' => 1100, 'REWARD' => 800 },
    'WEEKENDS' => { 'REGULAR' =>  900, 'REWARD' => 500 }
  },
  'GD2606' => {
    'WEEKDAYS' => { 'REGULAR' => 1600, 'REWARD' => 1100 },
    'WEEKENDS' => { 'REGULAR' =>  600, 'REWARD' => 500 }
  },
  'GD8732' => {
    'WEEKDAYS' => { 'REGULAR' => 2200, 'REWARD' => 1000 },
    'WEEKENDS' => { 'REGULAR' => 1500, 'REWARD' => 400 }
  },
  'GD2502' => {
    'WEEKDAYS' => { 'REGULAR' => 1700, 'REWARD' =>  800 },
    'WEEKENDS' => { 'REGULAR' =>  900, 'REWARD' => 800 }
  },
  'GD2607' => {
    'WEEKDAYS' => { 'REGULAR' => 1600, 'REWARD' => 1100 },
    'WEEKENDS' => { 'REGULAR' =>  600, 'REWARD' => 500 }
  },
  'GD8733' => {
    'WEEKDAYS' => { 'REGULAR' => 1600, 'REWARD' => 1500 },
    'WEEKENDS' => { 'REGULAR' => 1000, 'REWARD' => 400 }
  }
}

class Tickets
  attr_accessor :list

  def initialize(flights, customer, weekends)
    @list = []
    enlist(flights, customer, weekends)
  end


  def combinates_with(another)
    self.list.product(another.list)
  end

  private

  def enlist(flights, customer, weekends)
    flights.each do |flight|
      price = calculate_price(flight, customer.type, weekends)
      ticket = Ticket.new(flight[:number], price, flight[:sched])
      optimizing_add(ticket)
    end
  end

  def optimizing_add(ticket)
    if list.empty?
      @list << ticket
    else
      index = @list.find_index {|t| t == ticket }
      if index.nil?
        @list << ticket
      else
        @list[index] = ticket if ticket.better_than?(@list[index])
      end
    end
  end

  def calculate_price(flight, type, weekends)
    weekend_or_weekday = weekends ? 'WEEKENDS' : 'WEEKDAYS'
    FLIGHT_PRICES[flight[:number]][weekend_or_weekday][type]
  end
end

class LeavingTickets < Tickets
  def initialize(flights, customer)
    super(flights, customer, customer.departure_at_weekends)
  end
end

class ReturningTickets < Tickets
  def initialize(flights, customer)
    super(flights, customer, customer.return_at_weekends)
  end
end