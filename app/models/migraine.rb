class Migraine < ApplicationRecord
  NATURE_OPTIONS = %w[M H A MA MH].freeze
  NATURE_LABELS = {
    "M" => "Migraine (M)",
    "H" => "Headache (H)",
    "A" => "Migraine with aura (A)",
    "MA" => "Migraine with aura (MA)",
    "MH" => "Migraine with headache (MH)"
  }.freeze

  belongs_to :user

  validates :occurred_on, presence: true, uniqueness: { scope: :user_id }
  validates :nature, presence: true, inclusion: { in: NATURE_OPTIONS }
  validates :intensity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  validates :medication, length: { maximum: 100 }, allow_blank: true

  scope :for_month, ->(date) {
    start_date = date.beginning_of_month
    end_date = date.end_of_month
    where(occurred_on: start_date..end_date)
  }

  def to_h
    {
      nature: nature,
      intensity: intensity,
      on_period: on_period,
      medication: medication.presence
    }
  end
end
