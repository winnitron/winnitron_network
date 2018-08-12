class HighScore < ActiveRecord::Base
  belongs_to :game
  belongs_to :arcade_machine

  validates :name, :game, :score, presence: true

  def as_json(opts = {})
    except = ["game_id", "arcade_machine_id", "updated_at"]

    super(opts.merge(except: except)).merge({
      "game" => game.slug,
      "arcade_machine" => arcade_machine&.slug
    })
  end
end
