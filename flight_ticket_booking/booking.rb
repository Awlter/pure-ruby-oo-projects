require_relative 'customer'
require_relative 'packages'

CUSTOMER_TYPES = ['REWARD', 'REGULAR']
WEEK = ['MON', 'TUE', 'WED', 'TUR', 'FRI', 'SAT', 'SUN']

class Booker
  def process
    customer = Customer.new(*get_input)
    result = Packages.new(customer).cheapest
    output(result)
  end

  private

  def output(result)
    puts "OUTPUT:"
    puts result[0].flight
    puts result[1].flight
  end

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

    # for extensions: more destinations
    [type, departure_time, return_time, "XI'AN", "CHENGDU"]
  end

  def correct_input?(type, departure_time, return_time)
    (CUSTOMER_TYPES.include? type) &&
     (WEEK.include? departure_time) &&
      (WEEK.include? return_time)
  end
end

Booker.new.process