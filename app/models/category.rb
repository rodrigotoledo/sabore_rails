class Category < ApplicationRecord
  has_many :categories_establishments, dependent: :destroy
  has_many :establishments, through: :categories_establishments

  validates :name, presence: true, uniqueness: true
end
