class CommercialLand < Land
  def set_suggestion
    self.suggestion = "land for sale at #{place}"
  end

  def common_tags
    'land for sale place farm '
  end
end