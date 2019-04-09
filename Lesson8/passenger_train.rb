class PassengerTrain < Train
  @trains = {}

  def initialize(number)
    @type_of = :passenger
    super
  end
end
