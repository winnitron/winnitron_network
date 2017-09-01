class ApprovalRequest < ActiveRecord::Base
  include HasImages

  belongs_to :approvable, polymorphic: true

  def approved?
    !!approved_at
  end

  def refused?
    !!refused_at
  end
end
