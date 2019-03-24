class Attract < ActiveRecord::Base
  belongs_to :arcade_machine

  before_validation -> { self.starts_at ||= Time.now.utc.beginning_of_day }

  validates :text, :starts_at, :arcade_machine, presence: true
  validate :starts_before_ends

  def active?
    started? && !ended?
  end

  def ended?(now = Time.now.utc)
    !!(ends_at && ends_at <= now)
  end

  def started?(now = Time.now.utc)
    starts_at <= now
  end

  def as_json(opts = {})
    except = ["id", "arcade_machine_id", "created_at", "updated_at"]

    super(opts.merge(except: except)).merge({
      "arcade_machine" => arcade_machine.slug,
      "starts_at" => starts_at.iso8601,
      "ends_at" => ends_at&.iso8601
    })
  end

  private

  def starts_before_ends
    return if !ends_at
    if starts_at > ends_at
      errors.add(:base, "The start must be earlier than the end.")
    end
  end
end
