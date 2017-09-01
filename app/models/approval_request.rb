class ApprovalRequest < ActiveRecord::Base
  include HasImages

  belongs_to :approvable, polymorphic: true
end
