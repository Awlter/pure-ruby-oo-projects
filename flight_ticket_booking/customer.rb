class Customer
  WEEKENDS = ['SAT', 'SUN']

  attr_accessor :type, :departure_at_weekends, :return_at_weekends, :from, :to

  def initialize(type, departure_time, return_time, from, to)
    @type = type
    @departure_at_weekends = WEEKENDS.include? departure_time
    @return_at_weekends = WEEKENDS.include? return_time
    @from = from
    @to = to
  end
end