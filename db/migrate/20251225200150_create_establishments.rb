class CreateEstablishments < ActiveRecord::Migration[8.1]
  def change
    create_table :establishments do |t|
      t.string :name
      t.text :description
      t.string :address
      t.decimal :latitude
      t.decimal :longitude
      t.string :phone
      t.decimal :rating
      t.string :establishment_type

      t.timestamps
    end
  end
end
