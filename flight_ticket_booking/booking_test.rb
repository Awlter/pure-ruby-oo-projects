require 'minitest/autorun'
require_relative 'booking'

describe 'Ticket' do
  before do
    @ticket1 = Ticket.new('test1', 500, "12:00")
    @ticket2 = Ticket.new('test2', 500, "8:00")
    @ticket3 = Ticket.new('test3', 500, "14:00")
  end

  describe '# ==' do
    it 'must return true when two tickets prices are equal' do
      (@ticket1 == @ticket2).must_equal true
    end
  end

  describe '# better_than' do
    it 'returns true when the first ticket take-off time is around 12' do
      @ticket1.better_than?(@ticket2).must_equal true
    end

    it 'returns true when then first ticket take-off time is prior than the second' do
      @ticket2.better_than?(@ticket3).must_equal true
    end

    it 'return false when otherwise' do
      @ticket3.better_than?(@ticket1).must_equal false
    end
  end
end

describe 'Tickets' do
  it "returns optimized leaving ticket collection if two ticket prices are the same" do
    flights = [
      { number: 'GD2501', sched: '08:00'},
      { number: 'GD2606', sched: '12:25'},
      { number: 'GD8732', sched: '19:30'}
    ]

    customer = Customer.new('REWARD', 'SUN', 'SUN', 'any', 'any')

    tickets = LeavingTickets.new(flights, customer)

    tickets.list.map { |ticket| ticket.flight }.sort.must_equal ["GD2606", "GD8732"]
  end

  it "returns optimized returning ticket collection if two ticket prices are the same" do
    flights = [
      { number: 'GD2502', sched: '12:00'},
      { number: 'GD2607', sched: '16:25'},
      { number: 'GD8733', sched: '23:30'}
    ]

    customer = Customer.new('REGULAR', 'MON', 'MON', 'any', 'any')

    tickets = ReturningTickets.new(flights, customer)

    tickets.list.map { |ticket| ticket.flight }.sort.must_equal ["GD2502", "GD2607"]
  end
end

describe 'Packages' do
  before do
    @customer1 = Customer.new('REWARD', 'MON', 'MON', "XI'AN", "CHENGDU")
    @customer2 = Customer.new('REWARD', 'MON', 'SUN', "XI'AN", "CHENGDU")
    @customer3 = Customer.new('REWARD', 'SUN', 'MON', "XI'AN", "CHENGDU")
    @customer4 = Customer.new('REWARD', 'SUN', 'SUN', "XI'AN", "CHENGDU")
    @customer5 = Customer.new('REGULAR', 'MON', 'MON', "XI'AN", "CHENGDU")
    @customer6 = Customer.new('REGULAR', 'MON', 'SUN', "XI'AN", "CHENGDU")
    @customer7 = Customer.new('REGULAR', 'SUN', 'MON', "XI'AN", "CHENGDU")
    @customer8 = Customer.new('REGULAR', 'SUN', 'SUN', "XI'AN", "CHENGDU")
  end

  it "returns the right cheapest package according to the different input" do
    Packages.new(@customer1).cheapest.map {|t| t.flight}.must_equal(["GD2501", "GD2502"])
    Packages.new(@customer2).cheapest.map {|t| t.flight}.must_equal(["GD2501", "GD8733"])
    Packages.new(@customer3).cheapest.map {|t| t.flight}.must_equal(["GD8732", "GD2502"])
    Packages.new(@customer4).cheapest.map {|t| t.flight}.must_equal(["GD8732", "GD8733"])
    Packages.new(@customer5).cheapest.map {|t| t.flight}.must_equal(["GD2501", "GD2607"])
    Packages.new(@customer6).cheapest.map {|t| t.flight}.must_equal(["GD2501", "GD2607"])
    Packages.new(@customer7).cheapest.map {|t| t.flight}.must_equal(["GD2606", "GD2607"])
    Packages.new(@customer8).cheapest.map {|t| t.flight}.must_equal(["GD2606", "GD2607"])
  end
end
