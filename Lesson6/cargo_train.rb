class CargoTrain < Train
  def initialize(number)
    @type_of = :cargo
    super
  end  
end

