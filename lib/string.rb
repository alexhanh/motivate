String.class_eval do
  def is_i?(allow_signs = false)
    if allow_signs
      !!(self =~ /^[-+]?[0-9]+$/)
    else
      !!(self =~ /^[0-9]+$/)
    end
  end

  def is_numeric?
    begin Float(self) ; true end rescue false
  end
end