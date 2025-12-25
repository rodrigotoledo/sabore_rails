class Establishment < ApplicationRecord
  has_many :reservations, dependent: :destroy
  has_many :categories_establishments, dependent: :destroy
  has_many :categories, through: :categories_establishments
  has_one_attached :logo
  has_many_attached :photos

  validates :name, presence: true
  validates :address, presence: true
  validates :rating, presence: true, inclusion: { in: 0.0..5.0 }

  def display_logo
    if logo.attached?
      logo
    else
      # Fallback para placeholder baseado na primeira letra do nome
      nil
    end
  end

  def primary_category
    categories.first&.name || establishment_type&.humanize || "Restaurante"
  end
end
