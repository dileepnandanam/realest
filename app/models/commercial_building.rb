class CommercialBuilding < House
  def summary
    "#{area} square feet house at #{place}"
  end

  def set_suggestion
    self.suggestion = "building for sale at #{place}"
  end

  def common_tags
    ' kerala building '
  end
end