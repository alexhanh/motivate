# coding: utf-8
module GoalsHelper
  def wordify_weight_change_rate(weight_change_rate)
    if weight_change_rate.value < 0
      "laihduttaa #{weight_change_rate * -1} viikossa"
    elsif weight_change_rate.value > 0
      "lisätä painoa #{weight_change_rate} viikossa"
    else
      "säilyttää nykypainosi"
    end
  end
end
