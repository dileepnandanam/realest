class ResidentialHouse < House
  def summary
    "#{area} square feet house at #{place}"
  end

  def set_suggestion
    self.suggestion = "house for sale at #{place}"
  end

  def common_tags
    ' kerala house sale sell'
  end
end