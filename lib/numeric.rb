# Monkey-patch Numeric for 100.kg, 0.5.dl, etc.
Numeric.class_eval do
  Units.singleton_methods(false)[0..-3].each do |unit_sym|
    send :define_method, unit_sym do
      Quantity.new(self, Units.send(unit_sym))
    end
  end
end