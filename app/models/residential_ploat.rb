class ResidentialPloat < Land
  def summary
    acre1 = acre.to_i > 0 ? "#{acre} acre" : nil
    cent1 = cent.to_i > 0 ? "#{cent} cent" : nil
    [acre1, cent1, "ploat at #{place}"].select(&:present?).join(' ')
  end

  def set_suggestion
    self.suggestion = "ploat at #{place}"
  end

  def common_tags
    'ploat for sale'
  end
end