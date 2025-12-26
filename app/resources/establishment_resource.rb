# frozen_string_literal: true

class EstablishmentResource < ApplicationResource
  uri 'establishments'
  resource_name 'Establishments'
  description 'Exposes establishments for LLM/MCP usage.'
  mime_type 'application/json'

  def content
    JSON.generate(Establishment.all.as_json)
  end
end
