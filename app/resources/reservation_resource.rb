# frozen_string_literal: true

class ReservationResource < ApplicationResource
  uri "reservations"
  resource_name "Reservations"
  description "Exposes reservations for LLM/MCP usage."
  mime_type "application/json"

  def content
    JSON.generate(Reservation.all.as_json)
  end
end
