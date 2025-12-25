json.extract! establishment, :id, :name, :description, :address, :latitude, :longitude, :phone, :rating, :establishment_type, :created_at, :updated_at
json.url establishment_url(establishment, format: :json)
