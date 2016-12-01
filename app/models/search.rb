class Search
  attr_reader :klass, :keywords

  def initialize(klass, query)
    @klass = klass
    @keywords = query.gsub(/[^0-9a-z ]/i, "").split(" ").map(&:downcase)
  end

  def results
    @results ||= begin
      all_matches = (matches_by_tag + matches_by_title).uniq
      all_matches.sort_by { |item| relevancy_score(item) }.reverse
    end
  end

  private

  def matches_by_tag
    tags = ActsAsTaggableOn::Tag.joins(:taggings)
                                .where(name: keywords, taggings: { taggable_type: klass })
                                .uniq

    tags.map(&:taggings).flatten.map(&:taggable)
  end

  def matches_by_title
    klass.where("title ~* ?", keywords.join("|"))
  end

  def relevancy_score(item)
    tag_score = (item.tag_list & keywords).size
    title_score = keywords.select { |kw| item.title.downcase.include?(kw) }.size * 2

    tag_score + title_score
  end
end