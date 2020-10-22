class ResidentialPlot < Land
  def summary
    acre1 = acre.to_i > 0 ? "#{acre} acre" : nil
    cent1 = cent.to_i > 0 ? "#{cent} cent" : nil
    [acre1, cent1, "plot for sale at #{place}"].select(&:present?).join(' ')
  end

  def set_suggestion
    self.suggestion = "plot at #{place}"
  end

  def common_tags
    'plot plot place for sale '
  end
end