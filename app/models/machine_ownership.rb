class MachineOwnership < ActiveRecord::Base
  belongs_to :user
  belongs_to :arcade_machine
end
