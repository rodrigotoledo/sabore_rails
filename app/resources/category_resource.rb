# frozen_string_literal: true

class CategoryResource < ApplicationResource
  uri 'categories'
  resource_name 'Categories'
  description 'Exposes categories for LLM/MCP usage.'
  mime_type 'application/json'

  def content
    JSON.generate(Category.all.as_json)
  end
end
