class FilteredHighScores
  include Enumerable

  delegate :each, to: :@scores

  def initialize
    @scores = HighScore.all.order(score: :desc)
  end

  def game(game)
    @scores = @scores.where(game: game)
    self
  end

  def arcade(machine_id)
    @scores = if machine_id == "none"
      @scores.where(arcade_machine: nil)
    else
      found = ArcadeMachine.find_by_identifier(machine_id)
      found ? @scores.includes(:arcade_machine).where(arcade_machine: found) : @scores
    end

    self
  end

  def sandbox(test_mode)
    @scores = @scores.where(sandbox: test_mode)
    self
  end

  def order(sort)
    order_arg = case sort
    when Hash
      sort
    when "new"
      { id: :desc }
    when "old"
      { id: :asc }
    when "low"
      { score: :asc }
    else
      { score: :desc }
    end

    @scores = @scores.reorder(order_arg)
    self
  end

  def limit(lim)
    @scores = @scores.limit(lim)
    self
  end
end