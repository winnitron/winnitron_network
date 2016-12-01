class Search
  attr_reader :klass, :keywords

  def initialize(klass, query)
    @klass = klass
    @keywords = query.gsub(/[^0-9a-z ]/i, "").split(" ")
  end

  def results
    # This isn't the most ingenious but it'll work for now.
    @results ||= begin

      tags = ActsAsTaggableOn::Tag.where(name: keywords)
      all  = tags.map(&:taggings).flatten.map(&:taggable) # contains dupes

      # Count the number of times an object appears in the list
      # i.e. how large the intersection is of its tags and the keyword list
      relevancies = all.inject(Hash.new(0)) do |relevancy, item|
        relevancy[item] += 1
        relevancy
      end

      # Sort by most matching tags
      relevancies.sort_by { |k,v| -v }.map(&:first)
    end
  end
end