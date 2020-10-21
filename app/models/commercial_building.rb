class CommercialBuilding < House
  def summary
    "#{area} square feet building at #{place}"
  end

  def set_suggestion
    self.suggestion = "building for sale at #{place}"
  end

  def common_tags
    ' kerala building bilding shoping complex mall for sale sell '
  end
end