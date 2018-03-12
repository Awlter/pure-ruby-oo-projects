require 'pry'

class Booker
  CUSTOMER_TYPES = ['REWARD', 'REGULAR']
  WEEK = ['MON', 'TUE', 'WED', 'TUR', 'FRI', 'SAT', 'SUN']

  attr_accessor :customer_type, :departure_time, :return_time

  def start
    get_input
    result = Package.new(customer_type, departure_time, return_time)
    # output(result)
  end

  private

  def output(result)
    puts "OUTPUT:"
    puts result[0].flight
    puts result[1].flight
  end

  def get_input
    while true do
      puts "INPUT: (e.g: REWARD, 20160410SUN, 20160420WED)"
      inputs = gets.chomp.split(/\,\ ?/)
      @customer_type  = inputs[0].upcase 
      @departure_time = inputs[1][-3..-1].upcase
      @return_time    = inputs[2][-3..-1].upcase
      break if correct_input?
      puts "Please input with the suggested format."
    end
  end

  def correct_input?
    (CUSTOMER_TYPES.include? customer_type) &&
     (WEEK.include? departure_time) &&
      (WEEK.include? return_time)
  end
end

class Package
  FLIGHTS = [
    { number: 'GD2501', sched: '08:00', from: 'xian', to: 'chengdu' },
    { number: 'GD2606', sched: '12:25', from: 'xian', to: 'chengdu' },
    { number: 'GD8732', sched: '19:30', from: 'xian', to: 'chengdu' },
    { number: 'GD2502', sched: '12:00', to: 'xian', from: 'chengdu' },
    { number: 'GD2607', sched: '16:25', to: 'xian', from: 'chengdu' },
    { number: 'GD8733', sched: '23:30', to: 'xian', from: 'chengdu' },
  ]

  attr_reader :departure_tickets, :return_tickets

  def initialize(customer_type, departure_time, return_time)
    @departure_tickets = get_tickets(customer_type, departure_time, 'xian', 'chengdu')
    @return_tickets    = get_tickets(customer_type, return_time, 'chengdu', 'xian')
    find_lowest
  end

  def get_tickets(type, time, from, to)
    result = []
    FLIGHTS.each do |flight|
      result << Ticket.new(type, time, flight[:number], flight[:sched]) if flight[:from] == from && flight[:to] == to
    end
    result
  end

  def find_lowest
    packages = departure_tickets.product(return_tickets)
    lowests = packages.min(2) { |a, b| total_price(a) <=> total_price(b) }
    binding.pry
  end

  def total_price(package)
    package[0].price + package[1].price
  end
end

class Ticket
  FLIGHT_PRICES = {
    'GD2501' => { 'weekdays' => { 'REGULAR' => 1100, 'REWARD' =>  800 }, 'weekends' => { 'REGULAR' =>  900, 'REWARD' => 500 } },
    'GD2606' => { 'weekdays' => { 'REGULAR' => 1600, 'REWARD' => 1100 }, 'weekends' => { 'REGULAR' =>  600, 'REWARD' => 500 } },
    'GD8732' => { 'weekdays' => { 'REGULAR' => 2200, 'REWARD' => 1000 }, 'weekends' => { 'REGULAR' => 1500, 'REWARD' => 400 } },
    'GD2502' => { 'weekdays' => { 'REGULAR' => 1700, 'REWARD' =>  800 }, 'weekends' => { 'REGULAR' =>  900, 'REWARD' => 800 } },
    'GD2607' => { 'weekdays' => { 'REGULAR' => 1600, 'REWARD' => 1100 }, 'weekends' => { 'REGULAR' =>  600, 'REWARD' => 500 } },
    'GD8733' => { 'weekdays' => { 'REGULAR' => 1600, 'REWARD' => 1500 }, 'weekends' => { 'REGULAR' => 1000, 'REWARD' => 400 } }
  }

  WEEKENDS = ['SAT', 'SUN']

  attr_reader :price, :number

  def initialize(type, time, number, sched)
    @price = caculate_price(type, time, number)
    @number = number
    @sched = sched
  end

  def caculate_price(type, time, number)
    week = (WEEKENDS.include? time) ? 'weekends' : 'weekdays'
    FLIGHT_PRICES[number][week][type]
  end
end

Booker.new.start