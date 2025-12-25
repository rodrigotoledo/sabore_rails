class ExploreController < ApplicationController
  allow_unauthenticated_access

  def index
    @establishments = Establishment.all

    # Se receber coordenadas, ordenar por proximidade
    if params[:lat].present? && params[:lng].present?
      lat = params[:lat].to_f
      lng = params[:lng].to_f

      # Calcular distância aproximada usando fórmula de Haversine simplificada
      @establishments = @establishments.select { |e| e.latitude.present? && e.longitude.present? }
        .sort_by do |establishment|
          Math.sqrt(
            (establishment.latitude.to_f - lat) ** 2 +
            (establishment.longitude.to_f - lng) ** 2
          )
        end
    end
  end
end
