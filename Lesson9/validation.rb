module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(value, type_validation, *options)
      @validations ||= []
      @validations << { type: type_validation, name: value, options: options }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        var_name = instance_variable_get("@#{validation[:name]}")
        send(validation[:type], var_name, validation[:options])
      end
      true
    end

    def presence(value, options)
      raise "Имя не может быть пустым" if (value.nil? || value.to_s == "")
    end 

    def format(value, regex)
     raise "Неверный формат" if value !~ regex.first
    end

    def type(value, type_class)
      raise "Неверно задан класс" if value.kind_of?(type_class.first)
    end
  end
  
  protected

  def valid?
    validate!
  rescue StandardError
    false
  end
end

