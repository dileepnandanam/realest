class RentalHouse < House
  def summary
    "#{area} square feet house at #{place}"
  end

  def set_suggestion
    self.suggestion = "house for rent at #{place}"
  end

  def common_tags
    ' kerala house rent '
  end
end
