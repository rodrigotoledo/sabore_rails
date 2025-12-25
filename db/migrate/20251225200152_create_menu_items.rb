class CreateMenuItems < ActiveRecord::Migration[8.1]
  def change
    create_table :menu_items do |t|
      t.references :establishment, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.decimal :price
      t.string :photo

      t.timestamps
    end
  end
end
