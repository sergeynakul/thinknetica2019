class CarriagePassenger
  include Manufacturer
  
  attr_reader :type_of
  
  def initialize
    @type_of = :passenger
  end  
end  
