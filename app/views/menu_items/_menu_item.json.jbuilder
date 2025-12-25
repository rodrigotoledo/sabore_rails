json.extract! menu_item, :id, :establishment_id, :name, :description, :price, :photo, :created_at, :updated_at
json.url menu_item_url(menu_item, format: :json)
