class ApprovalRequest < ActiveRecord::Base
  include HasImages

  belongs_to :approvable, polymorphic: true

  scope :pending, -> { where(approved_at: nil) }
  scope :approved, -> { where.not(approved_at: nil) }
  scope :refused, -> { where.not(refused_at: nil) }

  def user
    approvable.users.first
  end

  def status
    return "approved" if approved?
    return "refused"  if refused?
    return "pending"
  end

  def approved?
    !!approved_at
  end

  def refused?
    !!refused_at
  end
end
