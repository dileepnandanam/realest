class RentalOffice < House
  def summary
    "#{area} square feet office for rent at #{place}"
  end

  def set_suggestion
    self.suggestion = "office for rent at #{place}"
  end

  def common_tags
    ' kerala office rent rental rented '
  end
end
