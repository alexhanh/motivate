class String
  def is_i?
     !!(self =~ /^[-+]?[0-9]+$/)
  end
  
  def is_numeric?
    begin Float(self) ; true end rescue false
  end
end