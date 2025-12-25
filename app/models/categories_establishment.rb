class CategoriesEstablishment < ApplicationRecord
  belongs_to :category
  belongs_to :establishment

  validates :category_id, uniqueness: { scope: :establishment_id }
end
