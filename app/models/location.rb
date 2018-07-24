class Location < ActiveRecord::Base
  belongs_to :parent, polymorphic: true

  def humanize
    [
      address,
      "#{city}, #{state}",
      country
    ].map(&:strip).reject(&:blank?).join("\n")
  end

  def abbreviated
    cs = [city, state].reject(&:blank?).join(", ")
    [cs, state, country].find(&:present?)
  end
end
