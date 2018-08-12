class ApiKey < ActiveRecord::Base
  validates :token, presence: true, uniqueness: true
  validates :secret, presence: true

  belongs_to :parent, polymorphic: true

  before_validation :generate_token

  private

  def generate_token
    loop do
      self.token = SecureRandom.hex(24)
      break if ApiKey.where(token: token).count == 0
    end

    self.secret = SecureRandom.hex(24)
  end
end
