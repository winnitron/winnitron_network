class FilteredHighScores
  include Enumerable

  delegate :each, to: :@scores

  def initialize
    @scores = HighScore.all
  end

  def game(game)
    @scores = @scores.where(game: game)
    self
  end

  def arcade(machine)
    machine = find_arcade_machine(machine)
    @scores = machine ? @scores.where(arcade_machine: machine) : @scores
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
    else
      { score: :desc }
    end

    @scores = @scores.reorder(order_arg)
    self
  end


  private

  def find_arcade_machine(winnitron_id)
    return winnitron_id if winnitron_id.is_a?(ArcadeMachine)

    key = ApiKey.find_by(token: winnitron_id, parent_type: "ArcadeMachine")
    key ? key.parent : ArcadeMachine.find_by(slug: winnitron_id)
  end

end