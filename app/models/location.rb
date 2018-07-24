class Location < ActiveRecord::Base
  geocoded_by :humanize
  after_validation :geocode

  belongs_to :parent, polymorphic: true

  def humanize
    [
      address,
      "#{city}, #{state}",
      country
    ].reject(&:blank?).map(&:strip).join("\n")
  end

  def abbreviate
    cs = [city, state].reject(&:blank?).join(", ")
    [cs, state, country].find(&:present?)
  end

end
