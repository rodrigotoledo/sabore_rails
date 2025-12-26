class Reservation < ApplicationRecord
  belongs_to :establishment
  belongs_to :user, optional: true

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :people_count, presence: true, numericality: { greater_than: 0 }
  validates :date, presence: true

  scope :anonymous, -> { where(user_id: nil) }
  scope :authenticated, -> { where.not(user_id: nil) }

  def anonymous?
    user_id.nil?
  end

  def confirmed?
    status == "confirmed"
  end
end
