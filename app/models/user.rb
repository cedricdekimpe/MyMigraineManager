class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :migraines, dependent: :destroy
  has_many :medications, dependent: :destroy

  after_create :ensure_default_medications

  private

  def ensure_default_medications
    %w[Ibuprofen Triptan].each do |name|
      medications.find_or_create_by(name: name)
    end
  end
end
