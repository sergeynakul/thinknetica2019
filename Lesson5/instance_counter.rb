module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def instances
      @instance.nil? ? 0 : @instance
    end

    private 

    def instances_count
      @instance ||= 0
      @instance += 1
    end
  end

  module InstanceMethods
    private 

    def register_instance
      self.class.send :instances_count
    end
  end
end
