# frozen_string_literal: true

class MenuItemResource < ApplicationResource
  uri 'menu_items'
  resource_name 'Menu Items'
  description 'Exposes menu items for LLM/MCP usage.'
  mime_type 'application/json'

  def content
    JSON.generate(MenuItem.all.as_json)
  end
end
