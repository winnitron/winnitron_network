class GameZip < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  validates :user, :file_key, :file_last_modified, presence: true
  validate :is_a_zip

  private

  def is_a_zip
    if file_key && file_key[-4..-1].downcase != ".zip"
      errors.add(:file_key, "must be a .zip file")
    end
  end
end