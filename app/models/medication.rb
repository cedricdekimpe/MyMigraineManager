class Medication < ApplicationRecord
  belongs_to :user
  has_many :migraines, dependent: :nullify

  validates :name, presence: true, length: { maximum: 100 }, uniqueness: { scope: :user_id, case_sensitive: false }

  before_validation :normalize_name

  def abbreviation
    name.to_s.strip.first&.upcase || "-"
  end

  private

  def normalize_name
    self.name = name.to_s.strip
  end
end
