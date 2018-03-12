require_relative 'tickets'

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

class Packages
  attr_accessor :customer, :packages

  def initialize(customer)
    @customer = customer
    @packages = []
    generate_packages
  end

  def cheapest
    packages.min { |a, b| total_price(a) <=> total_price(b) }
  end

  private

  def total_price(package)
    package[0].price + package[1].price
  end

  def generate_packages
    leaving_tickets = LeavingTickets.new(FLIGHTS[customer.from][customer.to], customer)
    returning_tickets = ReturningTickets.new(FLIGHTS[customer.to][customer.from], customer)
    self.packages = leaving_tickets.combinates_with(returning_tickets)
  end
end