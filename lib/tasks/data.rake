namespace :data do
  desc "Retroactively approve all arcade machines"
  task backfill_approvals: :environment do
    ArcadeMachine.all.each do |machine|
      ApprovalRequest.create(approvable: machine, notes: "Backfilled", approved_at: Time.now.utc)
    end
  end

  desc "Generate a bunch of fake gameplay data"
  task seed_gameplay: :environment do
    games = Game.limit(2)
    machines = ArcadeMachine.where(id: [3,6])

    plays = (7.days.ago.to_date..Date.today).map do |date|
      sessions = rand(10)

      sessions.times.map do

        start = date.to_time + rand(60 * 60 * 23).seconds
        stop  = start + (rand(20) + 1).minutes

        Play.create! game: games.sample,
           arcade_machine: machines.sample,
                    start: start,
                     stop: stop

      end
    end

  end
end
