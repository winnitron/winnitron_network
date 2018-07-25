class ApiKey < ActiveRecord::Base
  validates :token, presence: true, uniqueness: true
  validates :arcade_machine, presence: true

  belongs_to :arcade_machine

  before_validation :generate_token

  private

  def generate_token
    loop do
      self.token = SecureRandom.hex(24)
      break if ApiKey.where(token: token).count == 0
    end
  end
end
