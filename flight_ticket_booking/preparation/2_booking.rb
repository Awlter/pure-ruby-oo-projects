require 'pry'

class Booker
  def process
    customer = Customer.new
    result = Packages.new(customer).cheapest
  end

  private

  def output(result)
    puts "OUTPUT:"
    puts result[0].flight
    puts result[1].flight
  end

end

class Customer
  CUSTOMER_TYPES = ['REWARD', 'REGULAR']
  WEEK = ['MON', 'TUE', 'WED', 'TUR', 'FRI', 'SAT', 'SUN']
  WEEKENDS = ['SAT', 'SUN']

  attr_accessor :type, :departure_at_weekends, :return_at_weekends, :from, :to

  def initialize
    get_input
  end

  private

  def get_input
    type, departure_time, return_time = nil

    while true do
      puts "INPUT: (e.g: REWARD, 20160410SUN, 20160420WED)"
      inputs = gets.chomp.split(/\,\ ?/)
      type  = inputs[0].upcase 
      departure_time = inputs[1][-3..-1].upcase
      return_time    = inputs[2][-3..-1].upcase
      break if correct_input?(type, departure_time, return_time)
      puts "Please input with the suggested format."
    end

    @type = type
    @departure_at_weekends = WEEKENDS.include? departure_time
    @return_at_weekends = WEEKENDS.include? return_time

    # for extensions: e.g more places
    @from = "XI'AN"
    @to = "CHENGDU"
  end

  def correct_input?(type, departure_time, return_time)
    (CUSTOMER_TYPES.include? type) &&
     (WEEK.include? departure_time) &&
      (WEEK.include? return_time)
  end
end

class Packages
  FLIGHTS = {
    "XI'AN" => {
      "CHENGDU" => [
        { number: 'GD2501', sched: '08:00'},
        { number: 'GD2606', sched: '12:25'},
        { number: 'GD8732', sched: '19:30'}
      ]
    },
    "CHENGDU" => {
      "XI'AN" => [
        { number: 'GD2502', sched: '12:00'},
        { number: 'GD2607', sched: '16:25'},
        { number: 'GD8733', sched: '23:30'}
      ]
    }
  }

  attr_accessor :customer, :packages

  def initialize(customer)
    @customer = customer
    @packages = []
    generate_packages
  end

  def cheapest
    packages.min { |a, b| a.total_price <=> b.total_price }
  end

  private

  def generate_packages
    leaving_ticket = []
    returning_ticket = []

    FLIGHTS[customer.from][customer.to].each do |flight1|
      leaving_ticket << LeavingTicket.new(flight1, customer)
    end

    FLIGHTS[customer.to][customer.from].each do |flight2|
      returning_ticket << ReturningTicket.new(flight2, customer)
    end

    binding.pry
  end
end

class Package
  attr_reader :leaving_ticket, :returning_ticket

  def initialize(leaving_ticket, returning_ticket)
    @leaving_ticket   = leaving_ticket
    @returning_ticket = returning_ticket
  end

  def total_price
    leaving_ticket.price + returning_ticket.price
  end
end

class Ticket
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

  attr_reader :flight, :price

  def initialize(flight, customer, weekends)
    @flight = flight
    @price = calculate_price(customer.type, weekends)
  end

  def calculate_price(type, weekends)
    week = weekends ? 'WEEKENDS' : 'WEEKENDS'
    FLIGHT_PRICES[flight[:number]][week][type]
  end
end

class LeavingTicket < Ticket
  def initialize(flight, customer)
    super(flight, customer, customer.departure_at_weekends)
  end
end

class ReturningTicket < Ticket
  def initialize(flight, customer)
    super(flight, customer, customer.departure_at_weekends)
  end
end

Booker.new.process