# frozen_string_literal: true

class UserResource < ApplicationResource
  uri "users"
  resource_name "Users"
  description "Exposes users for LLM/MCP usage (no sensitive data)."
  mime_type "application/json"

  def content
    JSON.generate(User.select(:id, :email_address, :created_at, :updated_at).as_json)
  end
end
