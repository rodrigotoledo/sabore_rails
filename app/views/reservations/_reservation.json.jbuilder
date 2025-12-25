json.extract! reservation, :id, :establishment_id, :user_id, :date, :people_count, :status, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
