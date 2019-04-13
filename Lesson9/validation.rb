module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_reader :presence, :format, :type

    def validate(value, type_validation, *options)
      @presence = value if type_validation == :validate_presence
      @format = value, options if type_validation == :validate_format
      @type = value, options if type_validation == :validate_type
    end
  end

  module InstanceMethods
    def validate!
      if self.class.presence
        validate_presence(instance_variable_get("@#{self.class.presence}"))
      end  
      if self.class.format
        format = self.class.format
        validate_format(instance_variable_get("@#{format[0]}"), format[1])
      end  
      if self.class.type
        type = self.class.type
        validate_type(instance_variable_get("@#{type[0]}"), type[1])
      end
      true
    end

    def validate_presence(value, *options)
      raise "Имя не может быть пустым" if (value.nil? || value.to_s == "")
    end 

    def validate_format(value, regex)
     raise "Неверный формат" if value !~ regex.first
    end

    def validate_type(value, type_class)
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

class Test
  include Validation

  attr_accessor :name

  validate :name, :validate_presence
  #validate :name, :validate_format, /\D/
  validate :name, :validate_type, Integer

  def initialize(name)
    @name = name 
    validate!
  end
end

