class CargoCarriage
  include Manufacturer
  
  attr_reader :type_of

  def initialize
    @type_of = :cargo
  end  
end  
