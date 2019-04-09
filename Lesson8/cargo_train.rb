class CargoTrain < Train
  @trains = {}

  def initialize(number)
    @type_of = :cargo
    super
  end
end
