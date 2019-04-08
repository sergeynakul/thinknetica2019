class CargoCarriage
  include Manufacturer
  include Valid
  
  attr_reader :type_of, :volume, :volume_busy

  def initialize(volume)
    @volume = volume
    @volume_busy = 0
    @type_of = :cargo
  end  

  def engadged_volume(size)
    @volume_busy += size if (size < @volume)
  end

  def free_volume
    @volume -= @volume_busy
  end
end  
