module StatsHelper
  def build_plays_json(plays)
    {
      sessions: plays.map do |play|
        {
          game: {
            title: play.game.title,
            url: game_url(play.game.slug)
          },
          arcade: {
            name: play.arcade_machine.title,
            url:  arcade_machine_url(play.arcade_machine.slug)
          },
          start: play.start,
          stop: play.stop
        }
      end
    }
  end

  def build_plays_csv(plays)
    headers = "Arcade,Start,Stop"
    data = plays.map do |play|
      [
        play.arcade_machine.title,
        play.game.title,
        play.start,
        play.stop
      ].join(",")
    end

    ([headers] + data).join("\n")
  end
end
