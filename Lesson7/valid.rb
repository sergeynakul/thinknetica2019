module Valid
  protected

  def valid?
    validate!
  rescue
    false
  end
end
