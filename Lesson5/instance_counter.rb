module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instances_qty
      @instances
    end

    private 

    def instances_count(instance)
      @instances ||= 0
      @instances += instance
    end
  end

  module InstanceMethods
    private 

    def register_instance
      instance = 1
      self.class.send :instances_count, instance
    end
  end
end
