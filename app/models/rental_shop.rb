class RentalShop < House
  def summary
    "#{area} square feet shop for rent at #{place}"
  end

  def set_suggestion
    self.suggestion = "shop for rent at #{place}"
  end

  def common_tags
    ' kerala shop rent rental rented '
  end
end
