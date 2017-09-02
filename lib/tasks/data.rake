namespace :data do
  desc "Retroactively approve all arcade machines"
  task backfill_approvals: :environment do
    ArcadeMachine.all.each do |machine|
      ApprovalRequest.create(approvable: machine, notes: "Backfilled", approved_at: Time.now.utc)
    end
  end
end
