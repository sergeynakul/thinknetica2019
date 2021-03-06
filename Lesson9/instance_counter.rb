module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def instances
      @instances ||= 0
    end

    private

    def instances_count
      @instances ||= 0
      @instances += 1
    end
  end

  module InstanceMethods
    private

    def register_instance
      self.class.send :instances_count
    end
  end
end
