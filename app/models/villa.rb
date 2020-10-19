class Villa < House
  def summary
    "#{area} square feet villa at #{place}"
  end

  def set_suggestion
    self.suggestion = "villa for sale at #{place}"
  end

  def common_tags
    ' kerala villa '
  end
end