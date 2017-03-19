class LoggedEvent < ActiveRecord::Base
  belongs_to :actor, polymorphic: true
end