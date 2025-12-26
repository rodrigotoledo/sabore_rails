class CreateCategoriesEstablishments < ActiveRecord::Migration[8.1]
  def change
    create_table :categories_establishments do |t|
      t.references :category, null: false, foreign_key: true
      t.references :establishment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
