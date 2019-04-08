class CarriagePassenger
  include Manufacturer
  
  attr_reader :type_of, :seats, :seats_busy
  
  def initialize(seats)
    @seats = seats
    @seats_busy = 0
    @type_of = :passenger
  end 

  def engadged_seat
    @seats_busy += 1
  end    
 

  def free_seats 
    @seats -= @seats_busy
  end
end  
